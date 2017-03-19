# -*- coding: utf-8 -*-
#----------------------------------------------------------------------------#

# Purpose:     Parse & fill out background
# Project:     NLP Tool/Christmas Present
# Author:      Clara Marquardt
# Date:        2016

#----------------------------------------------------------------------------#

#----------------------------------------------------------------------------#
#                               Control Section                              #
#----------------------------------------------------------------------------#

# dependencies
#-------------------------------------------------#
import pdfminer

from pdfminer.pdfparser import PDFParser
from pdfminer.pdfdocument import PDFDocument
from pdfminer.pdfpage import PDFPage
from pdfminer.pdfpage import PDFTextExtractionNotAllowed
from pdfminer.pdfinterp import PDFResourceManager
from pdfminer.pdfinterp import PDFPageInterpreter
from pdfminer.pdfdevice import PDFDevice
from pdfminer.layout import LAParams
from pdfminer.converter import PDFPageAggregator

import os
import sys

import re

import glob

from random import randint


from PyPDF2 import PdfFileWriter, PdfFileReader

import StringIO

from reportlab.pdfgen import canvas
from reportlab.lib.pagesizes import letter
from reportlab.graphics.shapes import Rect
from reportlab.pdfgen.canvas import Canvas
from reportlab.lib.colors import PCMYKColor, PCMYKColorSep, Color, black, blue, red, white, green

import numpy as np
import pandas as pd

# control parameters
#-------------------------------------------------#
print 'Number of arguments:', len(sys.argv), 'arguments.'
print 'Argument List:', str(sys.argv)

# paths
input_path=sys.argv[1]
print input_path

# input_file_path=input_path+"/*_[0-9].pdf"
input_file_path=input_path+"/*.pdf"

output_path=sys.argv[2]
print output_path

# # set wd
# os.chdir(wd_path)

#----------------------------------------------------------------------------#
#                          Methods/Functions                                 #
#----------------------------------------------------------------------------#

# pdfPositionHandling - parse & extract line positions
#----------------------------------------------------------------------------#
class pdfPositionHandling:

    def parse_obj(self, lt_objs, pos_list, page_num):
    	position_list_new=pos_list

        # loop over the object list
        for obj in lt_objs:

            if isinstance(obj, pdfminer.layout.LTTextLine):
            	# print(obj.get_text().replace('\n', '_'))
                # print "%6d, %6d, %s" % (obj.bbox[0], obj.bbox[1], obj.get_text().replace('\n', '_'))
				# append to list
             	position_list_new.append([obj.bbox[0], obj.bbox[1], page_num,obj.get_text().replace('\n', '')])

            # if it's a textbox, also recurse
            if isinstance(obj, pdfminer.layout.LTTextBoxHorizontal):
                # print "textbox"
                self.parse_obj(obj._objs, position_list_new, page_num)

            # if it's a container, recurse
            elif isinstance(obj, pdfminer.layout.LTFigure):
                # print "container"
                self.parse_obj(obj._objs,position_list_new, page_num)

    def parsepdf(self, filename, startpage, endpage):

        # Open a PDF file.
        fp = open(filename, 'rb')

        # Create Position List
        position_list=[]

        # Create a PDF parser object associated with the file object.
        parser = PDFParser(fp)

        # Create a PDF document object that stores the document structure.
        # Password for initialization as 2nd parameter
        document = PDFDocument(parser)

        # Check if the document allows text extraction. If not, abort.
        if not document.is_extractable:
            raise PDFTextExtractionNotAllowed

        # Create a PDF resource manager object that stores shared resources.
        rsrcmgr = PDFResourceManager()

        # Create a PDF device object.
        device = PDFDevice(rsrcmgr)

        # BEGIN LAYOUT ANALYSIS
        # Set parameters for analysis.
        laparams = LAParams()

        # Create a PDF page aggregator object.
        device = PDFPageAggregator(rsrcmgr, laparams=laparams)

        # Create a PDF interpreter object.
        interpreter = PDFPageInterpreter(rsrcmgr, device)


        i = 0
        # loop over all pages in the document
        for page in PDFPage.create_pages(document):
            if i >= startpage and i <= endpage:
                # read the page into a layout object
                interpreter.process_page(page)
                layout = device.get_result()

                # extract text from this object
                # print(position_list)
                self.parse_obj(layout._objs,position_list, i)
                i += 1

        position_list = pd.DataFrame(position_list)
        position_list.columns=["pos_x", "pos_y", "page", "text"]

        return(position_list)


#----------------------------------------------------------------------------#
#                                    Code                                    #
#----------------------------------------------------------------------------#

for x in range(0, len(glob.glob(input_file_path))):

    fname     = glob.glob(input_file_path)[x]
    fname_abb = fname.split("/")[len(fname.split("/"))-1]
    print(fname)
    print(fname_abb)

    # parse PDF 
    #----------------------------------------------------------------------------#
    # read existing PDF
    existing_pdf             = PdfFileReader(file(fname, "rb"))
    existing_pdf_page_number = existing_pdf.getNumPages() 

    # parse
    position_class   = pdfPositionHandling()
    position         = position_class.parsepdf(fname, 0, existing_pdf_page_number)


    # extract products / product breaks
    #----------------------------------------------------------------------------#
    
    # coordinates
    x_min = min(position[position.pos_x>0]["pos_x"])
    x_min_min = x_min-15
    x_min_max = x_min+15

    x_max = max(position["pos_x"])

    # identify breaks
    product_break = []

    for i in range(0,existing_pdf_page_number):
        temp_1 = np.array(position.ix[position.page==i][position.pos_x<=x_min_max][
                 position["text"].str.contains("^[0-9]+([^A-Za-z])+[0-9]+([^A-Za-z]|[0-9])+")].pos_y)+10
        temp_1_index = position.ix[position.page==i][position.pos_x<=x_min_max][
                 position["text"].str.contains("^[0-9]+([^A-Za-z])+[0-9]+([^A-Za-z]|[0-9])+")].index
        temp_2 = np.array(position.ix[position.page==i][
                position["text"].str.contains("[0-9,\\.’ ]*Stck|Stk|St")].pos_y)-10
        temp_2_index = position.ix[position.page==i][
                position["text"].str.contains("[0-9,\\.’ ]*Stck|Stk|St")].index
        temp = np.concatenate([temp_1], axis=0)
        # temp = np.concatenate([temp_1, temp_2], axis=0)
        # temp_index = np.concatenate([temp_1_index, temp_2_index], axis=0)
        temp_index = np.concatenate([temp_1_index], axis=0)

        if (len(temp)>0):
            temp_mod = np.concatenate([temp[:-1][np.array(abs(temp_index[:-1]-temp_index[1:])!=1)], [temp[-1]]])
        else:
            temp_mod=temp
        product_break.append(temp_mod)

    # create a new PDF
    #----------------------------------------------------------------------------#
    can_list    = []
    packet_list = []
    pdf_list    = []

    for i in range(0,existing_pdf_page_number):
        packet_temp = StringIO.StringIO()
        can_temp    = canvas.Canvas(packet_temp)
        packet_list.append(packet_temp)
        can_list.append(can_temp)


    # draw line at product break - iterate through pages
    #----------------------------------------------------------------------------#

    # iterate & draw line/add text
    agg_product_num=1
    for page_num in range(0,existing_pdf_page_number):
        product_break_page = product_break[page_num]
        can_page = can_list[page_num]
        can_page.setFont('Helvetica', 10)
        for product_num in range(0,len(product_break_page)):
            can_page.setFillColor(black)
            can_page.line(x_min, product_break_page[product_num], x_max, product_break_page[product_num])
            can_page.setFillColor(green)
            can_page.drawString(x_min, product_break_page[product_num]+5, "#order-item: " + str(agg_product_num)+" ")
            agg_product_num+=1        

    for i in range(0,existing_pdf_page_number):
        can_list[i].save()
        packet_list[i].seek(0)
        pdf_list.append(PdfFileReader(packet_list[i]))
      

    # merge with background PDF
    #----------------------------------------------------------------------------#
    output = PdfFileWriter()

    for i in range(0,existing_pdf_page_number):
        page = existing_pdf.getPage(i)
        if pdf_list[i].getNumPages()>0:
            page.mergePage(pdf_list[i] .getPage(0))
        output.addPage(page)

    # save 
    outputStream = file(output_path + "/"+ fname_abb, "wb")
    output.write(outputStream)
    outputStream.close()

#----------------------------------------------------------------------------#
#                                    End                                     #
#----------------------------------------------------------------------------#


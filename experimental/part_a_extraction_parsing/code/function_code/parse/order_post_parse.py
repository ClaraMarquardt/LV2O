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
red50transparent = Color( 100, 0, 0, alpha=0.5)

import numpy as np
import pandas as pd

# control parameters
#-------------------------------------------------#
print 'Number of arguments:', len(sys.argv), 'arguments.'
print 'Argument List:', str(sys.argv)

# paths
input_path=sys.argv[1]
print input_path

input_file_path=input_path+"/*.csv"
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

# character encoding
#----------------------------------------------------------------------------#
def strip_non_ascii(string):
    ''' Returns the string without non ASCII characters'''
    stripped = (c for c in string if 0 < ord(c) < 127)
    return ''.join(stripped)

#----------------------------------------------------------------------------#
#                                    Code                                    #
#----------------------------------------------------------------------------#

# files
#----------------------------------------------------------------------------#

file_list = np.unique([x.split("/")[len(x.split("/"))-1].split("_order_id")[0] for x in 
                glob.glob(input_file_path)])

for x in range(0, len(file_list)):

    fname_pdf_abb = file_list[x]+".pdf"
    fname_pdf = input_path + "/"+ fname_pdf_abb

    print(fname_pdf_abb)

    # parse PDF 
    #----------------------------------------------------------------------------#
    # read existing PDF
    existing_pdf             = PdfFileReader(file(fname_pdf, "rb"))
    existing_pdf_page_number = existing_pdf.getNumPages() 

    # parse
    position_class   = pdfPositionHandling()
    position         = position_class.parsepdf(fname_pdf, 0, existing_pdf_page_number)
    position["text"] =[ strip_non_ascii(z) for z in position["text"] ]
    position["text"] =[ re.sub("\\(|\\)", "", z) for z in position["text"] ]

    # new PDF 
    #----------------------------------------------------------------------------#
    can_list    = []
    packet_list = []
    pdf_list    = []

    for i in range(0,existing_pdf_page_number):
        packet_temp = StringIO.StringIO()
        can_temp    = canvas.Canvas(packet_temp)
        packet_list.append(packet_temp)
        can_list.append(can_temp)


    # iterate through csvs
    #----------------------------------------------------------------------------#

    file_list_csv = glob.glob(input_path+'/' + file_list[x] + '*.csv')

    for y in range(0, len(file_list_csv)):

        fname      = re.sub("order_id_[0-9]*", "order_id_"+str(y), file_list_csv[1])
        fname_abb  = fname.split("/")[len(fname.split("/"))-1]

        print(fname_abb)

        # read csv
        #----------------------------------------------------------------------------#
        dt=pd.read_csv(fname)
        print dt

        dt["var_value"] = [strip_non_ascii(i) for i in dt["var_value"]]

        # identify text pos
        #----------------------------------------------------------------------------#
        
        # coordinates unicode(dt["var_value"][i], 'utf-8')
        position_subset =  []
        position_prod_subset=position.copy()
        position_prod_subset.ix[0, "text"]="#order-item: 0 " + position_prod_subset.ix[0, "text"]
        position_prod_subset.ix[position_prod_subset["text"].str.contains("#order-item: " + str(y)), 
            "min"]=0
        position_prod_subset.ix[position_prod_subset["text"].str.contains("#order-item: " + str(y+1)), 
            "min"]=1
        position_prod_subset.fillna(method="ffill", inplace=True)
        position_prod_subset=position_prod_subset.ix[position_prod_subset["min"]==0]
        position_prod_subset.reset_index(drop=True, inplace=True)
        
        for i in range(0,len(np.array(dt["var_value"]))):
            text_match = dt["var_value"][i]
            # text_match = re.sub("^[0-9 \\.]*", "",  text_match)
            # text_match = re.sub("[  ]*[a-z0-9\\\\A-Z]*$", "",  text_match)
            # text_match = re.sub("^[a-z0-9\\\\A-Z\\+]*[  ]*", "",  text_match)
            text_match = re.sub("^[+]*[ ]*", "",  text_match)
            text_match = re.sub("\\$", "",  text_match)
            text_match = re.sub("\\\\", "",text_match)
            text_match = re.sub("\\)", "",text_match)
            text_match = re.sub("\\(", "",text_match)
            text_match_temp = text_match.split("  ")
            text_match = text_match_temp[max(enumerate([len(v) for v in text_match_temp]),key=lambda x: x[1])[0]]
            temp=position_prod_subset.ix[position_prod_subset["text"].str.contains(text_match)]
            if (len(temp)>0):
                position_subset.append(np.array(temp)[0])
            else:   
                print "none"


        position_subset = pd.DataFrame(position_subset)
        if len(position_subset)>0:
            position_subset.columns = ["pos_x", "pos_y", "page", "text", "min"]
            position_subset.drop("min", axis=1, inplace=True)

        # draw box at text - iterate through pages
        #----------------------------------------------------------------------------#

        # iterate & draw line/add text
        for page_num in range(0,existing_pdf_page_number):
            if len(position_subset)>0:
                text_pos = position_subset.ix[position_subset["page"]==page_num]
                text_pos.reset_index(drop=True, inplace=True)
                can_page = can_list[page_num]
                for text_num in range(0,len(text_pos["pos_x"])):
                    x_1=text_pos.ix[text_num]["pos_x"]
                    y_1=text_pos.ix[text_num]["pos_y"]
                    can_page.setFillColor(red50transparent)
                    can_page.rect(x_1, y_1, 50, 10, fill=True, stroke=False)
        
          

    # merge with background PDF
    #----------------------------------------------------------------------------#
    for i in range(0,existing_pdf_page_number):
        can_list[i].save()
        packet_list[i].seek(0)
        pdf_list.append(PdfFileReader(packet_list[i]))

    output = PdfFileWriter()

    for i in range(0,existing_pdf_page_number):
        page = existing_pdf.getPage(i)
        if pdf_list[i].getNumPages()>0:
            page.mergePage(pdf_list[i].getPage(0))
        output.addPage(page)

    # save 
    outputStream = file(output_path + "/"+ re.sub("\\.pdf", "_mod.pdf", fname_pdf_abb), "wb")
    output.write(outputStream)
    outputStream.close()

#----------------------------------------------------------------------------#
#                                    End                                     #
#----------------------------------------------------------------------------#


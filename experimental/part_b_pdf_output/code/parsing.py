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

input_file_path=input_path+"/*_[0-9].pdf"

output_path=sys.argv[2]
print output_path

simulate=sys.argv[3]
print simulate

# # set wd
# os.chdir(wd_path)


#----------------------------------------------------------------------------#
#                          Methods/Functions                                 #
#----------------------------------------------------------------------------#

# pdfPositionHandling - parse & extract line positions
#----------------------------------------------------------------------------#
class pdfPositionHandling:

    def parse_obj(self, lt_objs, pos_list):
    	position_list_new=pos_list

        # loop over the object list
        for obj in lt_objs:

            if isinstance(obj, pdfminer.layout.LTTextLine):
            	# print(obj.get_text().replace('\n', '_'))
             #    print "%6d, %6d, %s" % (obj.bbox[0], obj.bbox[1], obj.get_text().replace('\n', '_'))
				# append to list
             	position_list_new.append([obj.bbox[0], obj.bbox[1], obj.get_text().replace('\n', '_')])

            # if it's a textbox, also recurse
            if isinstance(obj, pdfminer.layout.LTTextBoxHorizontal):
                self.parse_obj(obj._objs, position_list_new)

            # if it's a container, recurse
            elif isinstance(obj, pdfminer.layout.LTFigure):
                self.parse_obj(obj._objs,position_list_new)

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
                self.parse_obj(layout._objs,position_list)
            i += 1

        position_list = pd.DataFrame(position_list)
        position_list.columns=["pos_x", "pos_y", "text"]

        return(position_list)


#----------------------------------------------------------------------------#
#                                    Code                                    #
#----------------------------------------------------------------------------#

for fname in glob.glob(input_file_path):
    
    print(fname)
    
    file_name=fname.split("/")[len(fname.split("/"))-1]
    
    fname_csv=re.sub("pdf$", "txt_order_extracted.csv", fname)
    file_name_csv=fname_csv.split("/")[len(fname.split("/"))-1]

    # generate product id
    #----------------------------------------------------------------------------#
    
    if simulate=="True":
        print "simulate"
        info_csv=pd.read_csv(fname_csv)
    
        product_id_list=["prod_Axx","prod_Bxx","prod_Cxx","prod_Dxx", "prod_Exx", "prod_Fxx"]
        product_id=product_id_list[randint(0,(len(product_id_list)-1))]
        print(product_id)
        
        # random line number
        position_line=randint(0,30)
        print(position_line)
    
        info_csv_new=pd.DataFrame()
        info_csv_new["var"]=[ " ", "product_id", " ", "annotation_position_line", " ", "comments", " ", "reviewed_by", "reviewed_on"]
        info_csv_new["var_value"]=[" ",product_id, " ",(position_line+1) ," "," "," "," "," "]
    
        info_csv=pd.concat([info_csv,info_csv_new])
    
        info_csv.to_csv(output_path+"/"+file_name_csv, index=False)

    elif simulate=="False":
        print "non-simulate"
        info_csv=pd.read_csv(fname_csv)
        # product_id=info_csv.loc[info_csv["var"]=="product_id"]["var_value"]
        product_id=info_csv.iloc[4]["var_value"]
        # position_line=int(info_csv.loc[info_csv["var"]=="annotation_position_line"]["var_value"])
        position_line=int(info_csv.iloc[6]["var_value"])

        print(product_id)
        print(position_line)


    
    # parse PDF (extract position of squares)
    #----------------------------------------------------------------------------#
    position_class = pdfPositionHandling()
    position = position_class.parsepdf(fname, 0, 1)

    # print(position)

    # x1 = position[position.text=="line1_"]["pos_x"]
    # y1 = position[position.text=="line1_"]["pos_y"]

    x1 = max(position.ix[(position_line)]["pos_x"]-60, 0)
    y1 = position.ix[(position_line)]["pos_y"]+3

    print x1
    print y1
    # create a new PDF
    #----------------------------------------------------------------------------#
    packet = StringIO.StringIO()
    can = canvas.Canvas(packet)

    # randomly position white squares/text
    #----------------------------------------------------------------------------#

    # text
    # can.setFillColor(green)
    # can.setFont('Helvetica', 30)
    # can.drawString(x1, (y1+10), 'Hello')

    if simulate=="True":
        can.setFillColor(red)
    elif simulate=="False":
        can.setFillColor(green)

    can.setFont('Helvetica', 10)
    can.drawString(x1, y1, product_id)

    can.save()

    # merge with background PDF
    #----------------------------------------------------------------------------#
    # move to the beginning of the StringIO buffer
    packet.seek(0)
    new_pdf = PdfFileReader(packet)

    # read existing PDF
    existing_pdf = PdfFileReader(file(fname, "rb"))

    # add the "watermark" (new pdf) onto the existing PDF
    output = PdfFileWriter()
    page = existing_pdf.getPage(0)
    page.mergePage(new_pdf.getPage(0))
    output.addPage(page)

    # save 
    outputStream = file(output_path + "/" + file_name, "wb")
    output.write(outputStream)
    outputStream.close()

#----------------------------------------------------------------------------#
#                                    End                                     #
#----------------------------------------------------------------------------#


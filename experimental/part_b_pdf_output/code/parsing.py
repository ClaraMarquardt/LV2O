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

input_file_path=input_path+"/*_[0-9]_mod.pdf"

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
                self.parse_obj(obj._objs, position_list_new, page_num)

            # if it's a container, recurse
            elif isinstance(obj, pdfminer.layout.LTFigure):
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

file_list = glob.glob(input_file_path)

for x in range(0, len(file_list)):

    fname=file_list[x]
    file_name=fname.split("/")[len(fname.split("/"))-1]

    print(fname)
    print(file_name)

    # parse PDF 
    #----------------------------------------------------------------------------#
    # read existing PDF
    existing_pdf             = PdfFileReader(file(fname, "rb"))
    existing_pdf_page_number = existing_pdf.getNumPages() 

    # parse
    position_class   = pdfPositionHandling()
    position         = position_class.parsepdf(fname, 0, existing_pdf_page_number)
    
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

    file_list_csv = glob.glob(input_path+'/' + re.sub("_mod.pdf", "", file_name) + '*.csv')
    print file_list_csv
    for y in range(0, len(file_list_csv)):

        fname_csv=file_list_csv[y]
        file_name_csv=fname_csv.split("/")[len(fname.split("/"))-1]

        # generate product id
        #----------------------------------------------------------------------------#
        
        # determine number of rows 
        position_prod_subset=position.copy()
        position_prod_subset.ix[0, "text"]="#order-item: 0 " + position_prod_subset.ix[0, "text"]
        position_prod_subset.ix[position_prod_subset["text"].str.contains("#order-item: " + str(y)), 
            "min"]=0
        position_prod_subset.ix[position_prod_subset["text"].str.contains("#order-item: " + str(y+1)), 
             "min"]=1
        position_prod_subset.fillna(method="ffill", inplace=True)
        position_prod_subset=position_prod_subset.ix[position_prod_subset["min"]==0]

        min_index=position_prod_subset.index.min()
        max_index=position_prod_subset.index.max()

        position_prod_subset_alt=position.copy()
        max_index_glob_alt=position_prod_subset_alt.index.max()
        position_prod_subset_alt.ix[0, "text"]="#order-item: 0 " + position_prod_subset_alt.ix[0, "text"]
        min_index_alt=0
        max_index_alt=max_index_glob_alt

        if (len(np.array(position_prod_subset_alt[position_prod_subset_alt["text"].str.contains("#order-item: " + str(y))].index+5))>0):
            min_index_alt=np.array(position_prod_subset_alt[position_prod_subset_alt["text"].str.contains("#order-item: " + str(y))].index+5)[0]
        
        if (len(np.array(position_prod_subset_alt[position_prod_subset_alt["text"].str.contains("#order-item: " + str(y+1))].index+5))>0):
            max_index_alt=np.array(position_prod_subset_alt[position_prod_subset_alt["text"].str.contains("#order-item: " + str(y+1))].index+5)[0]
        
        position_prod_subset_alt=position_prod_subset_alt.ix[min_index_alt:max_index_alt]
           

        if simulate=="True":
            
            print "simulate"
            info_csv=pd.read_csv(fname_csv)
        
            product_id_list=["prod_Axx","prod_Bxx","prod_Cxx","prod_Dxx", "prod_Exx", "prod_Fxx"]
            product_id=product_id_list[randint(0,(len(product_id_list)-1))]
            print(product_id)

            # random line number
            # position_line=randint(min_index,max_index)
            id_line = position_prod_subset_alt[position_prod_subset_alt["text"].str.contains("(Stck( |$))|(Stk( |$))|(St( |$))")].index
            if (id_line.shape[0]>0):
                position_line=np.array(id_line)[0]
            else:
                position_line=min_index
                product_id="Non-Product Item"

            print(position_line)
        
            info_csv_new=pd.DataFrame()
            info_csv_new["var"]=[ " ", "product_id", " ", "annotation_position_line", " ", "comments", " ", "reviewed_by", "reviewed_on"]
            info_csv_new["var_value"]=[" ",product_id, " ",(position_line+1) ," ","Non-Product"," "," "," "]
        
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


        # parse PDF (extract position of 1st line - position ID at the left side)
        #----------------------------------------------------------------------------#

        # print(position)

        # x1 = position[position.text=="line1_"]["pos_x"]
        # y1 = position[position.text=="line1_"]["pos_y"]

        # x1   = max(position_prod_subset["pos_x"].min()-60, 10)
        # y1   = position.ix[(position_line)]["pos_y"]+3
        x1    = position.ix[(position_line)]["pos_x"]+50
        y1    = position.ix[(position_line)]["pos_y"]+3

        page1 = position.ix[(position_line)]["page"]
        print x1
        print y1
        print page1


        # randomly position white squares/text
        #----------------------------------------------------------------------------#

        if simulate=="True":
            FillColor=red
        elif simulate=="False":
            FillColor=green

        # draw box at text - iterate through pages
        #----------------------------------------------------------------------------#

        # iterate & draw line/add text
        can_page = can_list[page1]
        can_page.setFont('Helvetica', 10)
        can_page.setFillColor(FillColor)
        can_page.drawString(x1, y1, product_id)
        
          
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
            page.mergePage(pdf_list[i] .getPage(0))
        output.addPage(page)

    # save 
    outputStream = file(output_path + "/"+ file_name, "wb")
    output.write(outputStream)
    outputStream.close()



#----------------------------------------------------------------------------#
#                                    End                                     #
#----------------------------------------------------------------------------#

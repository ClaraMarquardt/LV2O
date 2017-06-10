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

import os, shutil
import sys
import datetime

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

import time

import numpy as np
import pandas as pd

## ignore warnings
import warnings
warnings.filterwarnings("ignore")


# control parameters
#-------------------------------------------------#
# print 'Number of arguments:', len(sys.argv), 'arguments.'
# print 'Argument List:', str(sys.argv)

# paths
input_path=sys.argv[1]
# print input_path

# input_file_path=input_path+"/*_[0-9].pdf"
input_file_path=input_path+"/*.pdf"
input_file_path_list= glob.glob(input_file_path)

output_path=sys.argv[2]
# print output_path

error_path=sys.argv[3]
# print error_path

archive_path=sys.argv[4]
# print error_path

log_path=sys.argv[5]
execution_id=sys.argv[6]
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
             #    print "%6d, %6d, %s" % (obj.bbox[0], obj.bbox[1], obj.get_text().replace('\n', '_'))
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

def flatten_list(container):
    for i in container:
        if isinstance(i, (list,tuple)):
            for j in flatten_list(i):
                yield j
        else:
            yield i

#----------------------------------------------------------------------------#
#                                    Code                                    #
#----------------------------------------------------------------------------#
start_time = time.time()

file_count = len(input_file_path_list)
file_count_sucess = 0

for x in range(0, len(input_file_path_list)):

    try:

        fname     = input_file_path_list[x]
        fname_abb = fname.split("/")[len(fname.split("/"))-1]
        print "parse order: " + str(x) + " out of " + str(len(input_file_path_list))
        print(fname)
        # print(fname_abb)

        # parse PDF 
        #----------------------------------------------------------------------------#
        # read existing PDF
        existing_pdf             = PdfFileReader(file(fname, "rb"), strict = False)
        existing_pdf_page_number = existing_pdf.getNumPages() 

        # parse
        position_class   = pdfPositionHandling()
        position         = position_class.parsepdf(fname, 0, existing_pdf_page_number)



        # extract products / product breaks
        #----------------------------------------------------------------------------#
        
        # coordinates
        x_min = min(position.ix[position.page==existing_pdf_page_number-1][position.pos_x>0]["pos_x"])
        # x_min = min(position[position.pos_x>0]["pos_x"])
        x_min_min = x_min-15
        x_min_max = x_min+15

        x_max = max(position["pos_x"])

        # determine hierarchy
        max_step = []

        for i in range(0,existing_pdf_page_number):
            position_page=position.ix[position.page==i].sort_values(["pos_y"], ascending=[0])
            position_page.reset_index(drop=True, inplace=True)
            temp_1 = np.array(position_page[position_page.pos_x<=x_min_max][
                     position_page["text"].str.contains("(^[0-9]+(\\.)+[0-9]+(\\.|[0-9])+)"+
                     "|([0-9]+(\\.)+[0-9]+(\\.|[0-9])+$)")].text)
            if(len(temp_1)==0):
                temp_1 = np.array(position_page[position_page.pos_x<=x_min_max][:-1][
                    position_page["text"].str.contains("(^[0-9]+(\\.)*)")].text)
            # temp_date = np.array(position_page[position_page.pos_x<=x_min_max][
            #          position_page["text"].str.contains("(^[0-9]+(\\.)+[0-9]+(\\.|[0-9])+(2016|2017))"+
            #          "|([0-9]+(\\.)+[0-9]+(\\.|[0-9])+(2016|2017)$)")].text)
            temp_date = np.array(position_page[position_page.pos_x<=x_min_max][
                     position_page["text"].str.contains("(^[ ]*[0-9][0-9](\\.)+[0-9][0-9](\\.)+(20)*(16|17))"+
                     "|([0-9][0-9](\\.)+[0-9][0-9](\\.)+(20)*(16|17))[ ]*$")].text)
        
            temp = np.setdiff1d(temp_1, temp_date)

            if(len(temp)>0):
                temp_step = np.hstack(np.array([re.sub("^[ ]*|[ ]$","", x).split(" ") for x in temp]))
                regex = re.compile('[0-9]')
                temp_step = [x for x in temp_step if regex.match(x)]
                temp_step = [re.sub("([0-9])($| )", "\g<1>.\g<2>", x) for x in temp_step]
                temp_step = np.array([[len(y) for y in re.sub("[^ \\.]","", x).split(" ")] for x in temp_step]).flatten()
                max_step.append(temp_step)


        max_step = np.sort(np.hstack(max_step))
        # max_step = max_step[max_step!=0]
        tab=np.bincount(max_step)
        if(max(tab[:-1])>tab[len(tab)-1]):
            max_step=np.unique(max_step)[len(np.unique(max_step))-2]
        else:
            max_step=np.unique(max_step)[len(np.unique(max_step))-1]
        # print(max_step)

        # identify breaks
        product_break =[]

        for i in range(0,existing_pdf_page_number):
            position_page=position.ix[position.page==i].sort_values(["pos_y"], ascending=[0])
            position_page.reset_index(drop=True, inplace=True)
            temp_1 = position_page[position_page.pos_x<=x_min_max][
                     position_page["text"].str.contains("(^[0-9]+([^A-Za-z])+[0-9]+([^A-Za-z]|[0-9])+)|"+
                     "([0-9]+([^A-Za-z])+[0-9]+([^A-Za-z]|[0-9])+$)")]
            if(len(temp_1)==0):
                temp_1 = position_page[position_page.pos_x<=x_min_max][:-1][
                    position_page["text"].str.contains("(^[0-9]+([^A-Za-z])*)")]
            temp_1["text_mod"]=[re.sub("[^ \\.0-9]","",x) for x in temp_1.text]
            temp_1["text_mod"]=[re.sub("^[ ]*|[ ]$","",x) for x in temp_1.text_mod]
            temp_1["text_mod"]=[re.sub("(?<![0-9])\\.","",x) for x in temp_1.text_mod]
            temp_1["text_mod"]=[re.sub("([0-9])($| )", "\g<1>.\g<2>",x) for x in temp_1.text_mod]  

            count = []
            for j in range(0, len( [x.split(" ") for x in temp_1.text_mod])):
                temp = [x.split(" ") for x in temp_1.text_mod][j]
                temp_length =  [re.sub("[^\\.]","",x) for x in temp]
                temp_length = max([len(y) for y in temp_length])
                count.append(temp_length)
          
            # temp_1["text_mod"]=[len(re.sub("[^\\.]","",x)) for x in temp_1.text_mod]
            temp_1["text_mod"] = count
            temp_1 = temp_1.ix[temp_1.text_mod>=max_step]
            temp_1_index = temp_1.index
            temp_1 = np.array(temp_1.pos_y)+10 
            # temp_2 = np.array(position_page[
            #         position_page["text"].str.contains("[0-9,\\.’ ]*Stck|Stk|St")].pos_y)-10
            # temp_2_index = position_page[
            #         position_page["text"].str.contains("[0-9,\\.’ ]*Stck|Stk|St")].index
            temp_date = np.array(position_page[position_page.pos_x<=x_min_max][
                        position_page["text"].str.contains("([0-9]+([^A-Za-z])*(2016|2017))|"
                        "([0-9]+([^A-Za-z])*(2016|2017))")].pos_y)+10  
            temp_date_index = position_page[position_page.pos_x<=x_min_max][
                         position_page["text"].str.contains("([0-9]+([^A-Za-z])+[0-9]*(2016|2017))|"
                         "([0-9]+([^A-Za-z])+[0-9]\*(2016|2017))")].index        
            temp = np.concatenate([temp_1], axis=0)
            if (len(temp_date)>0):
                temp = np.setdiff1d(temp, temp_date)[::-1]
            # temp = np.concatenate([temp_1, temp_2], axis=0)
            # temp_index = np.concatenate([temp_1_index, temp_2_index], axis=0)
            temp_index = np.concatenate([temp_1_index], axis=0)
            temp_index = np.setdiff1d(temp_index, temp_date_index)
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
            pdf_list.append(PdfFileReader(packet_list[i],strict=False))
          

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

        # update count
        file_count_sucess = file_count_sucess + 1

        # move file
        archive_file_path=archive_path + "/"+ fname_abb
        shutil.move(fname, archive_file_path)


    except:
        print "Error encountered"

        error_file_path = error_path + "/"+ fname_abb
        # os.rename(fname, error_file_path)
        shutil.copyfile(fname, error_file_path)
        archive_file_path=archive_path + "/"+ fname_abb
        shutil.move(fname, archive_file_path)


end_time = time.time()

# status
print "Number of PDFs: " + str(file_count)
print "Number of PDFs parsed succesfully: " + str(file_count_sucess)
print "Runtime (minutes):" + str((end_time - start_time))

orig_stdout = sys.stdout
log_file  = open(log_path+'/log_order_parse_py'+'.txt','a+')
sys.stdout = log_file

print "\n\n###############" 
print "Execution ID: " + execution_id
print "Date: " + str(datetime.date.today())

print "\n\nNumber of PDFs: " + str(file_count)
print "Number of PDFs parsed succesfully: " + str(file_count_sucess)
print "Runtime (minutes):" + str(end_time - start_time) 

sys.stdout = orig_stdout
log_file.close()

#----------------------------------------------------------------------------#
#                                    End                                     #
#----------------------------------------------------------------------------#


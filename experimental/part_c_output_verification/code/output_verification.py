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
updated_param=sys.argv[1]
print updated_param

file_path=sys.argv[2]
print file_path

input_path=sys.argv[3]
print input_path

output_path=sys.argv[4]
print output_path

output_path_final=sys.argv[5]
print output_path

#----------------------------------------------------------------------------#
#                          Methods/Functions                                 #
#----------------------------------------------------------------------------#

# identify csv
#----------------------------------------------------------------------------#
fname_csv=file_path
file_name_csv=fname_csv.split("/")[len(fname_csv.split("/"))-1]
print(file_name_csv)

fname=re.sub("txt_order_extracted.csv", "pdf", fname_csv)
file_name=fname.split("/")[len(fname.split("/"))-1]
print(file_name)

# update csv
#----------------------------------------------------------------------------#
updated_param=re.sub("\*\*\*\*\*", " ", updated_param)
param_list=updated_param.split("//////")

print param_list

info_csv=pd.read_csv(fname_csv)

for x in range(4, 11):
    info_csv.iloc[x]["var_value"]=param_list[x+1]

info_csv.to_csv(output_path+"/"+file_name_csv, index=False)
info_csv.to_csv(output_path_final+"/"+file_name_csv, index=False)

# update pdf
#----------------------------------------------------------------------------#


#----------------------------------------------------------------------------#
#                                    End                                     #
#----------------------------------------------------------------------------#


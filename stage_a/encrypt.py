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

# file
file_name=sys.argv[1]

#----------------------------------------------------------------------------#
#                                    Code                                    #
#----------------------------------------------------------------------------#

# parse PDF 
#----------------------------------------------------------------------------#
# read existing PDF
existing_pdf             = PdfFileReader(file(file_name, "rb"))

# check if encrypted
encrypt = existing_pdf.isEncrypted

sys.stdout.write(str(encrypt))
sys.exit(0)

#----------------------------------------------------------------------------#
#                                    End                                     #
#----------------------------------------------------------------------------#




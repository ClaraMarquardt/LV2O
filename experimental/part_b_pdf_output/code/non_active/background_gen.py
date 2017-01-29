#----------------------------------------------------------------------------#

# Purpose:     Generate (random) gap card
# Project:     NLP Tool/Christmas Present
# Author:      Clara Marquardt
# Date:        2016

#----------------------------------------------------------------------------#

#----------------------------------------------------------------------------#
#                               Control Section                              #
#----------------------------------------------------------------------------#

# dependencies
#-------------------------------------------------#
from PyPDF2 import PdfFileWriter, PdfFileReader

import StringIO

from reportlab.pdfgen import canvas
from reportlab.lib.pagesizes import letter
from reportlab.graphics.shapes import Rect
from reportlab.pdfgen.canvas import Canvas
from reportlab.lib.colors import PCMYKColor, PCMYKColorSep, Color, black, blue, red, white, green

from random import randint

import os

# control parameters
#-------------------------------------------------#

# paths
wd_path = "/Users/claramarquardt/Desktop/nlp_test/"
doc_path = "doc/"

background_file = "input_raw/background.pdf"
input_file = "input_mod/background_mod.pdf"

# positioning
x1 = randint(0,500)
y1 = randint(0,800)

x2 = randint(0,500)
y2 = randint(0,800)

# set wd
os.chdir(wd_path)

#----------------------------------------------------------------------------#
#                                    Code                                    #
#----------------------------------------------------------------------------#

# create a new PDF
#----------------------------------------------------------------------------#
packet = StringIO.StringIO()
can = canvas.Canvas(packet)

# randomly position white squares/text
#----------------------------------------------------------------------------#

can.setFillColor(white)
can.rect(x1,y1,100,100, fill=True, stroke=False)

can.setFillColor(white)
can.rect(x2,y2,100,100, fill=True, stroke=False)

# text
can.setFillColor(white)
can.setFont('Helvetica', 30)

can.drawString(x1, (y1+10), 'line1')
can.drawString(x2, (y2+10), 'line2')

can.save()

# merge with background PDF
#----------------------------------------------------------------------------#
# move to the beginning of the StringIO buffer
packet.seek(0)
new_pdf = PdfFileReader(packet)

# read existing PDF
existing_pdf = PdfFileReader(file(doc_path + background_file, "rb"))

# add the "watermark" (new pdf) onto the existing PDF
output = PdfFileWriter()
page = existing_pdf.getPage(0)
page.mergePage(new_pdf.getPage(0))
output.addPage(page)

# save 
outputStream = file(doc_path + input_file, "wb")
output.write(outputStream)
outputStream.close()

#----------------------------------------------------------------------------#
#                                    End                                     #
#----------------------------------------------------------------------------#


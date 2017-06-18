# -*- coding: utf-8 -*-
#----------------------------------------------------------------------------#

# Purpose:     Check whether PDF is encrypted/otherwise not parseable
# Author:      CM
# Date:        2016
# Language:    Python (.py)

#----------------------------------------------------------------------------#

#----------------------------------------------------------------------------#
#                               Control Section                              #
#----------------------------------------------------------------------------#


# control parameters
#-------------------------------------------------#

# paths
init_path=sys.argv[1]
file_name=sys.argv[2]

# dependencies
#-------------------------------------------------#
import sys
sys.path.append(init_path)

from python_init import *


#----------------------------------------------------------------------------#
#                                    Code                                    #
#----------------------------------------------------------------------------#

# parse PDF 
#----------------------------------------------------------------------------#

# read in PDF
existing_pdf             = PdfFileReader(file(file_name, "rb"))

# check if encrypted
encrypt = existing_pdf.isEncrypted

# return whether or not encrypted/not parseable
sys.stdout.write(str(encrypt))
sys.exit(0)

#----------------------------------------------------------------------------#
#                                    End                                     #
#----------------------------------------------------------------------------#




# -*- coding: utf-8 -*-
#----------------------------------------------------------------------------#

# Purpose:     Parse orders and generate master order file
# Author:      CM
# Date:        2016
# Language:    Python (.py)

#----------------------------------------------------------------------------#

#----------------------------------------------------------------------------#
#                               Control Section                              #
#----------------------------------------------------------------------------#

# control parameters
#-------------------------------------------------#
import sys

# paths
init_path=sys.argv[1]
input_path=sys.argv[2]
output_path=sys.argv[3]
error_path=sys.argv[4]
archive_path=sys.argv[5]
log_path=sys.argv[6]
execution_id=sys.argv[7]

# dependencies
#-------------------------------------------------#
sys.path.append(init_path)

from python_init import *

# parameters
#-------------------------------------------------#

# input path
input_file_path=input_path+"/*.pdf"
input_file_path=os.path.normpath(input_file_path)
input_file_path_list= glob.glob(input_file_path)

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

        # parse PDF 
        #----------------------------------------------------------------------------#
        # read existing PDF
        existing_pdf             = PdfFileReader(file(fname, "rb"), strict = False)
        existing_pdf_page_number = existing_pdf.getNumPages() 

        # parse
        position_class   = pdfPositionHandling()
        position         = position_class.parsepdf(fname, 0, existing_pdf_page_number)

        if (len(position[position['text'].str.contains("cid")])>len(position)-50):
            print error
        
        # extract products / product breaks
        #----------------------------------------------------------------------------#
        
        # coordinates
        x_min = min(position.ix[position.page==existing_pdf_page_number-1][position["text"].str.contains(":")==False][ 
            position["text"].str.contains("^[ ]*[0-9]")==True][position.pos_x>0 ]["pos_x"])
        if (x_min>np.mean(position["pos_x"])): 
            print error
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
            temp_date = np.array(position_page[position_page.pos_x<=x_min_max][
                     position_page["text"].str.contains("((^[ ]*[0-9][0-9](\\.)+[0-9][0-9](\\.)+(20)*(16|17))"+
                     "|([0-9][0-9](\\.)+[0-9][0-9](\\.)+(20)*(16|17))|([0-9][0-9](\\.|-)+[0-9][0-9].*:.*)[ ]*$)|(Tel\\.|Fax\\.)")].text)
            temp = np.setdiff1d(temp_1, temp_date)
            if(len(temp)>0):
                temp_step = np.hstack(np.array([re.sub("^[ ]*|[ ]$","", x).split(" ") for x in temp]))
                regex = re.compile('[0-9]')
                temp_step = [x for x in temp_step if regex.match(x)]
                temp_step = [re.sub("([0-9])($| )", "\g<1>.\g<2>", x) for x in temp_step]
                temp_step = np.array([[len(y) for y in re.sub("[^ \\.]","", x).split(" ")] for x in temp_step]).flatten()
                max_step.append(temp_step)


        max_step = np.sort(np.hstack(max_step))
        tab=np.bincount(max_step)

        if(len(tab)>1 and max(tab[:-1])>tab[len(tab)-1]):
            max_step=np.unique(max_step)[len(np.unique(max_step))-2]
        else:
            max_step=np.unique(max_step)[len(np.unique(max_step))-1]

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
          
            temp_1["text_mod"] = count
            temp_1 = temp_1.ix[temp_1.text_mod>=max_step]
            temp_1_index = temp_1.index
            temp_1 = np.array(temp_1.pos_y)+10 
            temp_date = np.array(position_page[position_page.pos_x<=x_min_max][
                        position_page["text"].str.contains("([0-9]+([^A-Za-z])*(2016|2017))|"
                        "([0-9]+([^A-Za-z])*(2016|2017))")].pos_y)+10  
            temp_date_index = position_page[position_page.pos_x<=x_min_max][
                         position_page["text"].str.contains("([0-9]+([^A-Za-z])+[0-9]*(2016|2017))|"
                         "([0-9]+([^A-Za-z])+[0-9]\*(2016|2017))|(Tel\\.|Fax\\.)")].index        
            temp = np.concatenate([temp_1], axis=0)
            if (len(temp_date)>0):
                temp = np.setdiff1d(temp, temp_date)[::-1]
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
        file_name = output_path + "/"+ fname_abb
        file_name = os.path.normpath(file_name)
        outputStream = file(file_name, "wb")
        output.write(outputStream)
        outputStream.close()

        # update count
        file_count_sucess = file_count_sucess + 1

        # move file
        archive_file_path=archive_path + "/"+ fname_abb
        archive_file_path=os.path.normpath(archive_file_path)
        shutil.move(fname, archive_file_path)


    except:
        print "Error encountered"

        error_file_path = error_path + "/"+ fname_abb
        error_file_path=os.path.normpath(error_file_path)
        shutil.copyfile(fname, error_file_path)
        archive_file_path=archive_path + "/"+ fname_abb
        archive_file_path=os.path.normpath(archive_file_path)
        shutil.move(fname, archive_file_path)


# Generate log file
# -----------------------------------------

end_time = time.time()

# status
print "Number of PDFs: " + str(file_count)
print "Number of PDFs parsed succesfully: " + str(file_count_sucess)
print "Runtime (minutes):" + str((end_time - start_time))

orig_stdout = sys.stdout

for log_filename in [log_path+'/stage_b_ii'+'.txt', log_path+'/stage_b_ii_'+execution_id+'.txt']:

    file_name=os.path.normpath(log_filename)
    log_file  = open(file_name,'a+')
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


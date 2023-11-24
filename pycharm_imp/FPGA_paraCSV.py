import csv

def rd_csv(path):
    file = open( path , 'r', encoding= 'utf-8')
    silst = csv.reader(file)
    for line in silst:
        print(line)
    file.close()

#def wr_CSV(spath):
#    file = open(spath, 'w', encoding=  'utf-8', newline= '')
#    swrite = csv.writer(file)
#    for i in range(3,2):
#        swrite.writerow(table_DDR)
#    file.close()

table_DDR = ['FPGA_zedboard', 1, 1, 1, 1, 1]

def appendCSV(spath):
    file = open(spath, 'a+', encoding=  'utf-8', newline= '')
    sWrite = csv.writer(file)
    for i in range(3,2):
        sWrite.writerow(table_DDR)
    file.close()

if __name__ == '__main__':

    path = 'ORB_record.csv'

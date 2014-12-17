# -*- coding: utf-8 -*-


import openpyxl


def sheet1(xls_book, sheet_names):
    xls_sheet = xls_book.get_sheet_by_name(sheet_names[0])

    xls_sheet["C2"] = 0.52
    xls_sheet["D2"] = 0.756
    xls_sheet["E2"] = 0.782
    
    
def sheet2():
    pass
    
    
def sheet3():
    pass
    

def main():
    
    xls_book = openpyxl.load_workbook(filename=r'template.xlsx')

    sheet_names = xls_book.get_sheet_names()


    xls_sheet = xls_book.get_sheet_by_name(sheet_names[0])

    xls_sheet["C2"] = 0.52
    xls_sheet["D2"] = 0.756
    xls_sheet["E2"] = 0.782

    xls_sheet = xls_book.get_sheet_by_name(sheet_names[1])

    xls_sheet["A1"] = "2014年11月试验中心主要设备（单班）利用率、完好率报表"
    xls_sheet["J3"] = 0.91

    xls_sheet = xls_book.get_sheet_by_name(sheet_names[2])

    print dir(xls_sheet)#.decode("utf8")

    print xls_sheet.title.encode("utf8")

    print xls_sheet.max_column
    #xls_sheet["AC4"] = 62.6

    xls_sheet.cell(row = 4, column = 28).value = 0.912
    xls_sheet.cell(row = 5, column = 28).value = 0.863

    xls_sheet.cell(row = 4, column = 29).value = 1
    xls_sheet.cell(row = 5, column = 29).value = 1

    excel_file = "report_201412.xlsx"

    xls_book.save(excel_file)
    
if __name__ == "__main__":

    main()
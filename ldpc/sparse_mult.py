import os
import time
import jinja2

env = jinja2.Environment(loader=jinja2.FileSystemLoader('templates'))
temp = env.get_template('sparse_mult.svt')

print("Starting Matrix A")
spmat = []
with open('matrix_A.txt', 'r') as fid:
    for line in fid:
        ldata = []
        for number in line.split(','):
            ldata.append(int(number))
        spmat.append(ldata)
#os.system('rm -f sparse_mult_by_A.sv')
os.system('del /Q sparse_mult_by_A.sv')
with open('sparse_mult_by_A.sv', 'w') as fid:
    print(temp.render(
            postfix='by_A',
            date=time.strftime("%m/%d/%Y"),
            input_width=8,
            output_width=96,
            in_length=144,
            out_length=11,
            sparse_matrix=spmat),
        file=fid)

# print("Starting Matrix B")
# spmat = []
# with open('matrix_B.txt', 'r') as fid:
#     for line in fid:
#         ldata = []
#         for number in line.split(','):
#             ldata.append(int(number))
#         spmat.append(ldata)
# os.system('rm -f sparse_mult_by_B.sv')
# with open('sparse_mult_by_B.sv', 'w') as fid:
#     print(temp.render(
#             date=time.strftime("%m/%d/%Y"),
#             input_width=96,
#             output_width=96,
#             in_length=11,
#             out_length=1,
#             sparse_matrix=spmat),
#         file=fid)

print("Starting Matrix C")
spmat = []
with open('matrix_C.txt', 'r') as fid:
    for line in fid:
        ldata = []
        for number in line.split(','):
            ldata.append(int(number))
        spmat.append(ldata)
#os.system('rm -f sparse_mult_by_C.sv')
os.system('del /Q sparse_mult_by_C.sv')
with open('sparse_mult_by_C.sv', 'w') as fid:
    print(temp.render(
            date=time.strftime("%m/%d/%Y"),
            input_width=8,
            output_width=96,
            in_length=144,
            out_length=1,
            sparse_matrix=spmat),
        file=fid)

# print("Starting Matrix E")
# spmat = []
# with open('matrix_E.txt', 'r') as fid:
#     for line in fid:
#         ldata = []
#         for number in line.split(','):
#             ldata.append(int(number))
#         spmat.append(ldata)
# os.system('rm -f sparse_mult_by_E.sv')
# with open('sparse_mult_by_E.sv', 'w') as fid:
#     print(temp.render(
#             date=time.strftime("%m/%d/%Y"),
#             input_width=96,
#             output_width=96,
#             in_length=11,
#             out_length=1,
#             sparse_matrix=spmat),
#         file=fid)
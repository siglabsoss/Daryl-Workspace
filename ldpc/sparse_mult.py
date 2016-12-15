import time
import jinja2

env = jinja2.Environment(loader=jinja2.FileSystemLoader('templates'))
temp = env.get_template('sparse_mult.svt')

spmat = []
with open('matrix_A.txt', 'r') as fid:
    for line in fid:
        ldata = []
        for number in line.split(','):
            ldata.append(int(number))
        spmat.append(ldata)

print(temp.render(
    date=time.strftime("%d/%m/%Y"),
    input_width=8,
    output_width=96,
    in_length=10,
    out_length=10,
    sparse_matrix=spmat))

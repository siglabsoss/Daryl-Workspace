import time
import jinja2

env = jinja2.Environment(loader=jinja2.FileSystemLoader('templates'))
temp = env.get_template('sparse_mult.svt')

print(temp.render(
    date=time.strftime("%d/%m/%Y"),
    in_length=10,
    out_length=10,
    sparse_matrix=[
        [1, 2, 3],
        [3, 4, 9],
        [0, 5, 6],
        [7, 8, 9],
        [0, 2, 4],
        [1, 5, 7],
        [0, 1],
        [9],
        [1, 2, 3],
        [0, 4, 8]
    ]))

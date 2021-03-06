import os, time
import numpy as np
import matplotlib.pyplot as pt
import jinja2

# Still need to debug this one (it is based heavily off of row2col)

# Parity Check Matrix (H) Parameters
z = 96 # expansion factor
M = 24 # rows / z
L = 12 # columns / z

H_shift = []
edge_exists = []
with open('Htmat.txt') as fid:
    for line in fid:
        shift_row, edge_row = [], []
        for term in line.split(','):
            shift_row.append((z - int(term)) % z)
            edge_row.append(bool(int(term) >= 0))
        H_shift.append(shift_row)
        edge_exists.append(edge_row)

# Keeps track of which output branch each input branch corresponds to
row2col_accumulator = np.zeros(z * L)
# Keeps track of which branch the current output should go to
to_branch =       7 * np.ones((z * M, 7), dtype=int)
to_index  = (z * L) * np.ones((z * M, 7), dtype=int)

indices = []
for row, shift_amount in enumerate(H_shift):
    for bnum, col in enumerate(np.nonzero(edge_exists[row])[0]):
        # print(np.nonzero(edge_exists[row])[0])
        shift = shift_amount[col]
        for zk in range(z):
            # print(z, zk, bnum, row, col, shift, (z * col + ((z - shift + zk) % z)))
            to_index[z*row + zk, bnum] = z * col + ((z - shift + zk) % z)
            to_branch[z*row + zk, bnum] = row2col_accumulator[to_index[z*row + zk, bnum]]
            row2col_accumulator[to_index[z*row + zk, bnum]] += 1

# print(np.sort(indices)/z)
# # for r2ca in np.sort(row2col_accumulator):
# #     print(r2ca)
# print(to_branch)
# print(row2col_accumulator[::z])

# pt.plot(row2col_accumulator)
# pt.show()

env = jinja2.Environment(loader=jinja2.FileSystemLoader('templates'))
temp = env.get_template('rom.svt')

#os.system('rm -f ldpc_column_to_row_rom.sv')
os.system('del /Q ldpc_column_to_row_rom.sv')
with open('ldpc_column_to_row_rom.sv', 'w') as fid:
    print(temp.render(
            romname='ldpc_column_to_row',
            date=time.strftime("%m/%d/%Y"),
            codeword_length=z*M,
            expansion_factor=z,
            row_count=np.arange(z*M),
            branches=6,
            branch_0=to_branch[:,0],
            branch_1=to_branch[:,1],
            branch_2=to_branch[:,2],
            branch_3=to_branch[:,3],
            branch_4=to_branch[:,4],
            branch_5=to_branch[:,5],
            branch_6=to_branch[:,6],
            index_0=to_index[:,0],
            index_1=to_index[:,1],
            index_2=to_index[:,2],
            index_3=to_index[:,3],
            index_4=to_index[:,4],
            index_5=to_index[:,5],
            index_6=to_index[:,6]),
        file=fid)
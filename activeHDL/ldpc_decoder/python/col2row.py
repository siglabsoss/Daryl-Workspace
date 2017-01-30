import numpy as np
import matplotlib.pyplot as pt

H_shift = []
edge_exists = []
with open('Hmat.txt') as fid:
	for line in fid:
		shift_row, edge_row = [], []
		for term in line.split(','):
			shift_row.append(int(term))
			edge_row.append(bool(int(term) >= 0))
		H_shift.append(shift_row)
		edge_exists.append(edge_row)

# Parity Check Matrix (H) Parameters
z = 96 # expansion factor
M = 12 # rows / z
L = 24 # columns / z

# Keeps track of which output branch each input branch corresponds to
col2row_accumulator = np.zeros(L)

branch_0 = []
branch

for row, shift_row in enumerate(H_shift):
	# Reports which output index each output branch corresponds to
	branch2index = np.nonzero(edge_exists[row])
    branch_0

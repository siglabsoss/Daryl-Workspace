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

histogram_accumulator = np.zeros()

# print(np.nonzero(edge_exists[0]))


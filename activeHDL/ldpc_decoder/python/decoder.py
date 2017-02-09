import numpy as np


class ParityCheckMatrix(object):
    """ ParityCheckMatrix """
    def __init__(self):
        self._load_pcm()
        self.nonzero_row_cache = dict()
        self.nonzero_col_cache = dict()
    
    def __get_item__(row, col):
        self._access_pcm(row, col)

    def _load_pcm(self):
        ''' load parity check matrix '''
        self.data = []
        with open('Hmat.txt', 'rt') as fid:
            for line in fid:
                self.data.append([])
                for shift_entry_text in line.split(','):
                    shift_entry = int(shift_entry_text)
                    self.data[-1].append(shift_entry)
        self.data = np.array(self.data)

    def source_row_to_dest(self, row):
        if row in self.nonzero_row_cache:
            to_col, to_branch = self.nonzero_row_cache[row]
            return to_col, to_branch
        to_col, to_branch = [], []

        for col in range(2304):
            if self._access_pcm(row, col):
                # Nonzero element, need to discover its destination column and branch
                to_col.append(col)
                branch_num = 0
                for pre_row in range(row):
                    if self._access_pcm(pre_row, col):
                        branch_num += 1
                to_branch.append(branch_num)

        self.nonzero_row_cache[row] = to_col, to_branch
        return to_col, to_branch

    def source_col_to_dest(self, col):
        if col in self.nonzero_col_cache:
            to_row, to_branch = self.nonzero_col_cache[col]
            return to_row, to_branch
        to_row, to_branch = [], []

        for row in range(1152):
            if self._access_pcm(row, col):
                # Nonzero element, need to discover its destination row and branch
                to_row.append(row)
                branch_num = 0
                for pre_col in range(col):
                    if self._access_pcm(row, pre_col):
                        branch_num += 1
                to_branch.append(branch_num)

        self.nonzero_col_cache[col] = to_row, to_branch
        return to_row, to_branch

    def _access_pcm(self, row, col):
        row96 = row // 96
        col96 = col // 96
        if self.data[row96, col96] >= 0:
            shift_entry = self.data[row96, col96]
            if (row - col) % 96 == shift_entry:
                return True
        return False

    def __repr__(self):
        return self.data.__repr__()

    def __str__(self):
        return self.data.__str__()


def min_signer(inp):
    ''' inp = list of N LLR values '''
    # Sign calculations
    s = inp < 0
    s_total = np.logical_xor.reduce(s)
    
    # Magnitude calculations
    m = np.abs(inp)
    midx = np.argmin(m)
    m0, m1 = np.min(m), np.min(m[np.arange(m.size) != midx])

    # Choose outputs
    outp = []
    for k, sk in enumerate(s):
        if k != midx:
            if s_total ^ sk:
                outp.append(-m0)
            else:
                outp.append(m0)
        else:
            if s_total ^ s[k]:
                outp.append(-m1)
            else:
                outp.append(m1)
    
    return np.array(outp)


def summer(inp):
    ''' inp = list of N LLR values '''
    outp, accum = [], np.sum(inp)
    
    for k, xk in enumerate(inp):
        outp.append(accum - xk)
    
    return np.array(outp)


def decoder(inp, H):
    alphas = np.zeros((8, 2304))
    betas = np.zeros((8, 1152))
    llrs = np.zeros(2304)

    for k, llr in enumerate(inp):
        # Need to worry about order here
        to_col, to_branch = H.source_col_to_dest(k)
        betas[to_branch, to_col] = llr
        llrs[k] = llr


    for iter in range(20):
        for row in range(1152):
            # For referencing order/length information
            to_col, to_branch = H.source_row_to_dest(row)
            # Perform update operation
            betas_in = betas[:len(to_col), row]
            alphas_out = min_signer(betas_in)
            # Need to worry about order here
            for b, col, alpha in zip(to_branch, to_col, alphas_out):
                alphas[b, col] = alpha

        for col in range(2304):
            # For referencing order/length information
            to_row, to_branch = H.source_col_to_dest(col)
            # Perform update operation
            alphas_in = alphas[:len(to_row), col]
            betas_out = summer(alphas_in) + llrs[col]
            # Need to worry about order here
            for b, row, beta in zip(to_branch, to_row, betas_out):
                betas[b, row] = beta

    outp = []
    for col in range(1152):
        alphas_in = alphas[:len(to_row), col]
        betas_out = np.sum(alphas_in) + llrs[col]
        if betas_out < 0:
            outp.append(1)
        else:
            outp.append(0)

    return outp


if __name__ == '__main__':
    # 96 = 3 * 2**5
    H = ParityCheckMatrix()
    print(H)

    x = (-1)**np.arange(2304)
    y = decoder(x, H)

    for yk in y:
        print(yk, end=', ')

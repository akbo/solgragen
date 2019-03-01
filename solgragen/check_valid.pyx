cdef inline int numbers_unique(char[9] values):
    cdef char nonzero_counts[10]
    nonzero_counts[:] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

    for i in range(9):
        nonzero_counts[values[i]] += 1
    
    for i in range(1,10):
        if nonzero_counts[i] > 1:
            return 0
    return 1

def is_valid_grid(python_grid):
    cdef char cgrid[9][9]
    for r in range(9):
        for c in range(9):
            cgrid[r][c] = python_grid[r][c]
    
    retval = cis_valid_grid(cgrid)
    if retval:
        return True
    else:
        return False
    
cdef inline int cis_valid_grid(char[9][9] grid):

    cdef char area[9]
    cdef int br, bc, i, b

    # columns
    for c in range(9):
        for i in range(9):
            area[i] = grid[i][c]
        if not numbers_unique(area):
            return 0

    # rows
    for r in range(9):
        for i in range(9):
            area[i] = grid[r][i]
        if not numbers_unique(area):
            return 0

    # blocks
    for b in range(9):
        br = b // 3
        bc = b % 3
        i = 0
        for r in range(br * 3, (br + 1) * 3):
            for c in range(bc * 3, (bc + 1) * 3):
                area[i] = grid[r][c]
                i += 1
        if not numbers_unique(area):
            return 0

    return 1

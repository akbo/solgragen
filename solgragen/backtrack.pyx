from solgragen.check_valid cimport cis_valid_grid


def backtrack(python_grid):
    cdef char cgrid[9][9]
    for r in range(9):
        for c in range(9):
            cgrid[r][c] = python_grid[r][c]
    return cbacktrack(cgrid)


cdef cbacktrack(char[9][9] igrid):
    cdef int zr, zc

    zero_found = False
    for zero_r in range(9):
        for zero_c in range(9):
            if igrid[zero_r][zero_c] == 0:
                if not zero_found:
                    zr = zero_r
                    zc = zero_c
                    zero_found = True

    if not zero_found:
        # grid full, return a python grid
        python_grid = []
        for r in range(9):
            python_row = []
            for c in range(9):
                python_row.append(igrid[r][c])
            python_grid.append(python_row)
        return [python_grid]

    # make copy of input grid so we don't write on the caller's grid
    cdef char grid[9][9]
    for r in range(9):
        for c in range(9):
            grid[r][c] = igrid[r][c]

    valid_full_grids = []
    for value in range(1, 10):
        grid[zr][zc] = value
        if cis_valid_grid(grid):
            valid_full_grids += cbacktrack(grid)
    return valid_full_grids

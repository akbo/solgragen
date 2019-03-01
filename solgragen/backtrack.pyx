import numpy as np
from solgragen.check_valid cimport cis_valid_grid


def backtrack(char[:,:] grid):
    cdef char cgrid[9][9]
    for r in range(9):
        for c in range(9):
            cgrid[r][c] = grid[r, c]
    return cbacktrack(cgrid)


cdef cbacktrack(char[9][9] igrid):
    cdef int zr, zc
    cdef char[:,:] ngrid_view

    zero_found = False
    for zero_r in range(9):
        for zero_c in range(9):
            if igrid[zero_r][zero_c] == 0:
                if not zero_found:
                    zr = zero_r
                    zc = zero_c
                    zero_found = True

    if not zero_found:
        # grid full, return a numpy grid
        ngrid = np.zeros([9,9], dtype=np.int8)
        ngrid_view = ngrid
        for r in range(9):
            for c in range(9):
                ngrid_view[r, c] = igrid[r][c]
        return [ngrid]

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

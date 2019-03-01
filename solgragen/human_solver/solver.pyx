import numpy as np


from solgragen.human_solver import logger


from solgragen.human_solver.cleanup cimport cleanup
from solgragen.human_solver.utils cimport grid_full, values_only
from solgragen.human_solver.naked_single cimport naked_single
from solgragen.human_solver.unique cimport unique
from solgragen.human_solver.naked_pair cimport naked_pair


from solgragen.backtrack cimport cbacktrack
from solgragen.draw_grid cimport draw


def solve(char[:,:] ngrid):
    cdef char grid[9][9][10]
    cdef char values_only_grid[9][9]
    cdef char[:,:] ngrid_view    

    # copy grid and initialize candidates
    for r in range(9):
        for c in range(9):
            grid[r][c][0] = ngrid[r, c]
            if ngrid[r, c]:
                for i in range(1,10):
                    grid[r][c][i] = 0
            else:
                for i in range(1,10):
                    grid[r][c][i] = 1

    cdef int grid_changed = 0
    cdef int max_level = 0

    cleanup(grid)
    draw(grid)
    while True:

        if grid_full(grid):
            # grid full, return a numpy grid
            ngrid = np.zeros([9,9], dtype=np.int8)
            ngrid_view = ngrid
            for r in range(9):
                for c in range(9):
                    ngrid_view[r, c] = grid[r][c][0]
            return ngrid

        # Level 0 Strategies
        grid_changed = naked_single(grid)
        if grid_changed:
            continue

        grid_changed = unique(grid)
        if grid_changed:
            continue

        # Level 1 Strategies
        grid_changed = naked_pair(grid)
        if grid_changed:
            continue

        # Level 2 Strategies

        # Level 3 Strategies

        # Level 4 Strategies
        logger.info("backtracking...")
        # logger.info(cformat_grid(grid))
        # draw(grid)
        values_only(grid, values_only_grid)
        return cbacktrack(values_only_grid)[0]

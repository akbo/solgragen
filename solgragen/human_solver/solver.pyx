from solgragen.human_solver import logger


from solgragen.human_solver.cleanup cimport cleanup
from solgragen.human_solver.utils cimport grid_full, values_only, init_grid
from solgragen.human_solver.naked_single cimport naked_single
from solgragen.human_solver.unique cimport unique
from solgragen.human_solver.naked_pair cimport naked_pair
from solgragen.human_solver.hidden_pair cimport hidden_pair


from solgragen.backtrack cimport cbacktrack
from solgragen.draw_grid cimport draw


def solve(python_grid):
    python_grid = python_grid[:]

    cdef char grid[9][9][10]
    cdef char values_only_grid[9][9]
    cdef int grid_changed = 0
    cdef int max_level = 0

    init_grid(python_grid, grid)

    while True:

        if grid_full(grid):
            # grid full, return a python grid
            python_grid = []
            for r in range(9):
                python_row = []
                for c in range(9):
                    python_row.append(grid[r][c][0])
                python_grid.append(python_row)
            return python_grid

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

        grid_changed = hidden_pair(grid)
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

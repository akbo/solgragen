from solgragen.human_solver import logger
from solgragen.human_solver.utils cimport set_cell


cdef int naked_single(char[9][9][10] grid):
    '''
    Cells with only a single candidate are set to this candidate
    '''
    cdef int candidate_count, last_candidate
    cdef int grid_changed = 0

    for r in range(9):
        for c in range(9):
            candidate_count = 0
            last_candidate = 0
            for candidate in range(1,10):
                if grid[r][c][candidate]:
                    last_candidate = candidate
                    candidate_count += 1
            if candidate_count == 1:
                logger.info(f"naked single: set [{r}, {c}] to {last_candidate}")
                set_cell(grid, r, c, last_candidate)
                grid_changed = 1
    return grid_changed

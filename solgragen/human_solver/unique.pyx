'''
If a candidate is only present in a single cell of a row, a column or a block, it must be the solution of the cell
'''


from solgragen.human_solver import logger
from solgragen.human_solver.utils cimport row, col, block, block_idx, set_cell


cdef int unique(char[9][9][10] grid):
    global row, col, block

    cdef char area_idxs[9][2]
    cdef int grid_changed, candidate
    for candidate in range(1,10):

        # rows
        for r in range(9):
            row(r, area_idxs)
            grid_changed = candidate_unique(grid, area_idxs, candidate)
            if grid_changed:
                return 1

        # cols
        for c in range(9):
            col(c, area_idxs)
            grid_changed = candidate_unique(grid, area_idxs, candidate)
            if grid_changed:
                return 1            

        # blocks
        for b in range(9):
            block(b, area_idxs)
            grid_changed = candidate_unique(grid, area_idxs, candidate)
            if grid_changed:
                return 1  

    return 0


cdef int candidate_unique(char[9][9][10] grid, char[9][2] area_idxs, int candidate):
    cdef int candidate_count = 0
    cdef int r, c, last_r, last_c

    for i in range(9):
        r = area_idxs[i][0]
        c = area_idxs[i][1]
        if grid[r][c][candidate]:
            candidate_count += 1
            last_r = r
            last_c = c

    if candidate_count == 1:
        logger.info(f"unique: set [{last_r}, {last_c}] to {candidate}")
        set_cell(grid, last_r, last_c, candidate)
        return 1
    else:
        return 0

from solgragen.human_solver.utils cimport row, col, block, block_idx
from solgragen.human_solver import logger


cdef void cleanup(char[9][9][10] grid):
    for r in range(9):
        for c in range(9):
            if grid[r][c][0]:
                cleanup_cell(grid, r, c)


cdef void cleanup_cell(char[9][9][10] grid, int r, int c):
    cdef int cell_value = grid[r][c][0]
    cdef char area_idxs[9][2]

    # row
    row(r, area_idxs)
    eliminate_candidate(grid, area_idxs, cell_value)

    # col
    col(c, area_idxs)
    eliminate_candidate(grid, area_idxs, cell_value)

    # block
    block(block_idx(r, c), area_idxs)
    eliminate_candidate(grid, area_idxs, cell_value)


cdef void eliminate_candidate(char[9][9][10] grid, char[9][2] area_idxs, int candidate):
    cdef int r, c

    for i in range(9):
        r = area_idxs[i][0]
        c = area_idxs[i][1]
        if grid[r][c][candidate]:
            logger.info(f"cleanup: eliminated candidate {candidate} in cell [{r}, {c}]")
            grid[r][c][candidate] = 0

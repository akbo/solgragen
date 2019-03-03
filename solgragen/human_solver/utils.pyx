from solgragen.check_valid cimport cis_valid_grid
from solgragen.human_solver.cleanup cimport cleanup, cleanup_cell
from solgragen.human_solver import logger

cdef void row(int r, char[9][2] output):
    for c in range(9):
        output[c][0] = r
        output[c][1] = c


cdef void col(int c, char[9][2] output):
    for r in range(9):
        output[r][0] = r
        output[r][1] = c


cdef void block(int b, char[9][2] output):
        cdef int br, bc, i
        br = b // 3
        bc = b % 3
        i = 0
        for r in range(br * 3, (br + 1) * 3):
            for c in range(bc * 3, (bc + 1) * 3):
                output[i][0] = r
                output[i][1] = c
                i += 1


cdef int block_idx(int r, int c):
    return r // 3 * 3 + c // 3


cdef void set_cell(char[9][9][10] grid, int r, int c, char solution):
    grid[r][c][0] = solution
    for candidate in range(1,10):
        grid[r][c][candidate] = 0

    cleanup_cell(grid, r, c)

    # check if grid is valid
    cdef char values_only_grid[9][9]
    values_only(grid, values_only_grid)
    if not cis_valid_grid(values_only_grid):
        logger.error("invalid grid!!")


cdef int grid_full(char[9][9][10] grid):
    cdef int full = 1

    for zero_r in range(9):
        for zero_c in range(9):
            if grid[zero_r][zero_c][0] == 0:
                full = 0

    return full


cdef void values_only(char[9][9][10] grid, char[9][9] values_only_grid):
    for r in range(9):
        for c in range(9):
            values_only_grid[r][c] = grid[r][c][0]

cdef void init_grid(object pgrid, char[9][9][10] grid):
    # copy grid and initialize candidates
    for r in range(9):
        for c in range(9):
            grid[r][c][0] = pgrid[r][c]
            if grid[r][c][0]:
                for i in range(1, 10):
                    grid[r][c][i] = 0
            else:
                for i in range(1, 10):
                    grid[r][c][i] = 1
    cleanup(grid)
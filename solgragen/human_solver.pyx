import numpy as np
from loguru import logger

from solgragen.check_valid cimport cis_valid_grid
from solgragen.backtrack cimport cbacktrack
from solgragen.utils cimport cformat_grid
from solgragen.draw_grid cimport draw

logger.remove()
logger.add("human_solver.log")

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


cdef values_only(char[9][9][10] grid, char[9][9] values_only_grid):
    for r in range(9):
        for c in range(9):
            values_only_grid[r][c] = grid[r][c][0]


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


cdef void eliminate_candidate(char[9][9][10] grid, char[9][2] area_idxs, int candidate):
    cdef int r, c

    for i in range(9):
        r = area_idxs[i][0]
        c = area_idxs[i][1]
        if grid[r][c][candidate]:
            logger.info(f"cleanup: eliminated candidate {candidate} in cell [{r}, {c}]")
            grid[r][c][candidate] = 0


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


cdef void cleanup(char[9][9][10] grid):
    for r in range(9):
        for c in range(9):
            if grid[r][c][0]:
                cleanup_cell(grid, r, c)


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

cdef int unique(char[9][9][10] grid):
    '''
    If a candidate is only present in a single cell of a row, a column or a block, it must be the solution of the cell
    '''
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

cdef int naked_pair_area(char[9][9][10] grid, char[9][2] area_idxs, int candidate1, int candidate2):
    cdef int grid_changed = 0
    cdef int n_fitting_cells = 0
    cdef char fitting_cell_idxs[2][2]
    cdef int r, c, only_candidates_in_cell

    # find cells containing only the two candidates as candidates
    for cell_idx in range(9):
        r = area_idxs[cell_idx][0]
        c = area_idxs[cell_idx][1]

        if grid[r][c][candidate1] and grid[r][c][candidate2]:

            only_candidates_in_cell = 1
            for candidate in range(1,10):
                if (candidate != candidate1) and (candidate != candidate2):
                    if grid[r][c][candidate]:
                        only_candidates_in_cell = 0
            
            if only_candidates_in_cell:
                if n_fitting_cells == 2:
                    logger.error("error: naked pair in more than 2 cells")
                else:
                    fitting_cell_idxs[n_fitting_cells][0] = r
                    fitting_cell_idxs[n_fitting_cells][1] = c
                    n_fitting_cells += 1

    # if two fitting cells found, eliminate candidates in other cells
    if n_fitting_cells == 2:
        # logger.info(f"found naked pair - candidates: {candidate1}, {candidate2}; cells: ({fitting_cell_idxs[0][0]}, {fitting_cell_idxs[0][1]}), ({fitting_cell_idxs[1][0]}, {fitting_cell_idxs[1][1]})")
        # draw(grid)
        for cell_idx in range(9):
            r = area_idxs[cell_idx][0]
            c = area_idxs[cell_idx][1]

            if (not ((r == fitting_cell_idxs[0][0]) and (c == fitting_cell_idxs[0][1]))) and (
                not ((r == fitting_cell_idxs[1][0]) and (c == fitting_cell_idxs[1][1]))
            ):
                if grid[r][c][candidate1]:
                    grid[r][c][candidate1] = 0
                    logger.info(f"naked pair: eliminated candidate {candidate1} in cell [{r}, {c}]")
                    grid_changed = 1

                if grid[r][c][candidate2]:
                    grid[r][c][candidate2] = 0
                    logger.info(f"naked pair: eliminated candidate {candidate2} in cell [{r}, {c}]")
                    grid_changed = 1
    
    return grid_changed


cdef int naked_pair(char[9][9][10] grid):
    '''
    If there are two candidates that are only valid for two cells in an area, those two candidates must fill the two cells. Thus, the two candidates can be removed from all other cells of the area.
    '''
    global row, col, block

    cdef char area_idxs[9][2]
    cdef int grid_changed, candidate1, candidate2

    for candidate1 in range(9):
        for candidate2 in range(candidate1 + 1, 9):

            # rows
            for r in range(9):
                row(r, area_idxs)
                grid_changed = naked_pair_area(grid, area_idxs, candidate1, candidate2)
                if grid_changed:
                    return 1

            # cols
            for c in range(9):
                col(c, area_idxs)
                grid_changed = naked_pair_area(grid, area_idxs, candidate1, candidate2)
                if grid_changed:
                    return 1            

            # blocks
            for b in range(9):
                block(b, area_idxs)
                grid_changed = naked_pair_area(grid, area_idxs, candidate1, candidate2)
                if grid_changed:
                    return 1  

    return 0

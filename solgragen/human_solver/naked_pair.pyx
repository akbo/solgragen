from solgragen.human_solver import logger
from solgragen.human_solver.utils cimport row, col, block, block_idx


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
        for cell_idx in range(9):
            r = area_idxs[cell_idx][0]
            c = area_idxs[cell_idx][1]

            if (not ((r == fitting_cell_idxs[0][0]) and (c == fitting_cell_idxs[0][1]))) and (
                not ((r == fitting_cell_idxs[1][0]) and (c == fitting_cell_idxs[1][1]))
            ):
                if grid[r][c][candidate1]:
                    logger.info(f"naked pair: eliminating candidate {candidate1} in cell [{r}, {c}]")
                    grid[r][c][candidate1] = 0
                    grid_changed = 1

                if grid[r][c][candidate2]:
                    logger.info(f"naked pair: eliminating candidate {candidate2} in cell [{r}, {c}]")
                    grid[r][c][candidate2] = 0
                    grid_changed = 1
    
    return grid_changed

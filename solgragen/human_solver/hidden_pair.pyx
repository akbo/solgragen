from solgragen.human_solver import logger
from solgragen.human_solver.utils cimport row, col, block, block_idx


cdef int hidden_pair(char[9][9][10] grid):
    global row, col, block

    cdef char area_idxs[9][2]
    cdef int grid_changed, candidate1, candidate2

    for candidate1 in range(9):
        for candidate2 in range(candidate1 + 1, 9):

            # rows
            for r in range(9):
                row(r, area_idxs)
                grid_changed = hidden_pair_area(grid, area_idxs, candidate1, candidate2)
                if grid_changed:
                    return 1

            # cols
            for c in range(9):
                col(c, area_idxs)
                grid_changed = hidden_pair_area(grid, area_idxs, candidate1, candidate2)
                if grid_changed:
                    return 1            

            # blocks
            for b in range(9):
                block(b, area_idxs)
                grid_changed = hidden_pair_area(grid, area_idxs, candidate1, candidate2)
                if grid_changed:
                    return 1  

    return 0


cdef int hidden_pair_area(char[9][9][10] grid, char[9][2] area_idxs, int candidate1, int candidate2):
    cdef int grid_changed = 0
    cdef int n_only_cand1 = 0, n_only_cand2 = 0, n_both_cand = 0
    cdef char both_cand_cell_idxs[9][2]
    cdef int r, c

    # find all cells containing the candidates
    for cell_idx in range(9):
        r = area_idxs[cell_idx][0]
        c = area_idxs[cell_idx][1]

        if grid[r][c][candidate1] and grid[r][c][candidate2]:
            both_cand_cell_idxs[n_both_cand][0] = r
            both_cand_cell_idxs[n_both_cand][1] = c
            n_both_cand += 1
        
        elif grid[r][c][candidate1] and (not grid[r][c][candidate2]):
            n_only_cand1 += 1

        elif (not grid[r][c][candidate1]) and grid[r][c][candidate2]:
            n_only_cand2 += 1

    # if there are two cells containing both candidates and the candidates are in no other cells, eliminate all other candidates in the two cells containing both candidates
    if (n_both_cand == 2) and (n_only_cand1 == 0) and (n_only_cand2 == 0):

        for cell_idx in range(2):
            r = both_cand_cell_idxs[cell_idx][0]
            c = both_cand_cell_idxs[cell_idx][1]

            for candidate in range(1, 10):
                if (not candidate == candidate1) and (not candidate == candidate2):
                    if grid[r][c][candidate]:
                        logger.info(f"hidden pair: eliminating candidate {candidate} in cell [{r}, {c}]")
                        grid[r][c][candidate] = 0
                        grid_changed = 1
    
    return grid_changed

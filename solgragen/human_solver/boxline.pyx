from solgragen.human_solver import logger


cdef int boxline(char[9][9][10] grid):
    global row, col, block

    cdef char area_idxs[9][2]
    cdef int grid_changed, b

    # blocks
    for b in range(9):
        grid_changed = check_box(grid, b)
        if grid_changed:
            return 1  

    return 0


cdef int check_box(char[9][9][10] grid, int b):
    cdef int grid_changed = 0
    cdef int box_rows[3], box_cols[3]
    cdef int candidate_seen_outside_box

    box_rows[0] = 3 * (b // 3)
    box_rows[1] = 3 * (b // 3) + 1
    box_rows[2] = 3 * (b // 3) + 2

    box_cols[0] = 3 * (b % 3)
    box_cols[1] = 3 * (b % 3) + 1
    box_cols[2] = 3 * (b % 3) + 2

    for candidate in range(1, 10):

        # rows
        for check_row_idx in range(3):
            check_row = box_rows[check_row_idx]
            if (
                grid[check_row][box_cols[0]][candidate]
                or grid[check_row][box_cols[1]][candidate]
                or grid[check_row][box_cols[2]][candidate]
            ):
                candidate_seen_outside_box = 0
                for c in range(9):
                    if (c != box_cols[0]) and (c != box_cols[1]) and (c != box_cols[2]):
                        if grid[check_row][c][candidate]:
                            candidate_seen_outside_box = 1
                if not candidate_seen_outside_box:
                    for clean_row_idx in range(3):
                        if check_row_idx != clean_row_idx:
                            clean_row = box_rows[clean_row_idx]
                            for clean_col_idx in range(3):
                                clean_col = box_cols[clean_col_idx]
                                if grid[clean_row][clean_col][candidate]:
                                    grid_changed = 1
                                    logger.info(f"boxline (box {b}, row {check_row}): eliminating candidate {candidate} in cell [{clean_row}, {clean_col}]")
                                    grid[clean_row][clean_col][candidate] = 0
                if grid_changed:
                    return 1


        # cols
        for check_col_idx in range(3):
            check_col = box_cols[check_col_idx]
            if (
                grid[box_rows[0]][check_col][candidate]
                or grid[box_rows[1]][check_col][candidate]
                or grid[box_rows[2]][check_col][candidate]
            ):
                candidate_seen_outside_box = 0
                for r in range(9):
                    if (r != box_rows[0]) and (r != box_rows[1]) and (r != box_rows[2]):
                        if grid[r][check_col][candidate]:
                            candidate_seen_outside_box = 1
                if not candidate_seen_outside_box:
                    for clean_col_idx in range(3):
                        if check_col_idx != clean_col_idx:
                            clean_col = box_cols[clean_col_idx]
                            for clean_row_idx in range(3):
                                clean_row = box_rows[clean_row_idx]
                                if grid[clean_row][clean_col][candidate]:
                                    grid_changed = 1
                                    logger.info(f"boxline (box {b}, col {check_col}): eliminating candidate {candidate} in cell [{clean_row}, {clean_col}]")
                                    grid[clean_row][clean_col][candidate] = 0
                if grid_changed:
                    return 1


    return 0

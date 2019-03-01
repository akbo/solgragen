import numpy as np


def parse_grid(grid_str):
    return np.array([int(c) for c in grid_str], dtype=np.int8).reshape((9, 9))

cdef cformat_grid(char[9][9][10] grid):
    cdef char[:,:] ngrid_view    

    ngrid = np.zeros([9,9], dtype=np.int8)
    ngrid_view = ngrid
    for r in range(9):
        for c in range(9):
            ngrid_view[r, c] = grid[r][c][0]
    return format_grid(ngrid)


def format_grid(grid):
    def format_block(block):
        return " ".join([str(e) for e in block]).replace("0", " ")

    def format_row_band(row_band):
        formatted_rows = []
        for row in row_band:
            formatted_rows.append(
                "|".join(
                    [format_block(block) for block in [row[:3], row[3:6], row[6:]]]
                )
            )
        return formatted_rows

    separator = "-----+-----+-----"

    rows = format_row_band(grid[:3])
    rows.append(separator)
    rows += format_row_band(grid[3:6])
    rows.append(separator)
    rows += format_row_band(grid[6:])
    return "\n".join(rows)


def col_coords(r, c):
    return [(i, c) for i in range(9) if i != r]


def row_coords(r, c):
    return [(r, i) for i in range(9) if i != c]


def block_coords(r, c):
    block_row = r // 3
    block_col = c // 3
    return [
        (i, j)
        for i in range(block_row * 3, (block_row + 1) * 3)
        for j in range(block_col * 3, (block_col + 1) * 3)
        if (i, j) != (r, c)
    ]


def field_values(grid, coord_list):
    rows, cols = np.transpose(coord_list)
    return grid[rows, cols]


def col_values(grid, r, c):
    return field_values(grid, col_coords(r, c))


def row_values(grid, r, c):
    return field_values(grid, row_coords(r, c))


def block_values(grid, r, c):
    return field_values(grid, block_coords(r, c))

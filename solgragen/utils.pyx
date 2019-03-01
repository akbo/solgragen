def parse_grid(grid_str):
    grid = []
    for r in range(9):
        grid.append([int(c) for c in grid_str[r * 9 : (r + 1) * 9]])
    return grid


cdef cformat_grid(char[9][9][10] grid):
    python_grid = []
    for r in range(9):
        row = []
        for c in range(9):
            row.append(grid[r][c][0])
        python_grid.append(row)
    return format_grid(python_grid)


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

from solgragen.human_solver.unique cimport unique
from solgragen.human_solver.cleanup cimport cleanup
from solgragen.utils import parse_grid


def test_unique():
    pgrid = parse_grid("000000012050400000000000030700600400001000000000080000920700800000510700000003000")

    cdef char grid[9][9][10]

    # copy grid and initialize candidates
    for r in range(9):
        for c in range(9):
            grid[r][c][0] = pgrid[r][c]
            if pgrid[r][c]:
                for i in range(1, 10):
                    grid[r][c][i] = 0
            else:
                for i in range(1, 10):
                    grid[r][c][i] = 1

    cleanup(grid)
    unique(grid)

    assert grid[6][8][0] == 1

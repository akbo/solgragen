from solgragen.human_solver.boxline cimport boxline
from solgragen.human_solver.utils cimport init_grid
from solgragen.utils import parse_grid


def test_boxline():
    cdef char grid[9][9][10]
    init_grid(
        parse_grid(
            "820040013401200000600100042300462501514300267200517304042031000100000420080024130"
        ),
        grid,
    )

    boxline(grid)

    assert (grid[7][1][7] == 0) and (grid[7][2][7] == 0) and (grid[8][2][7] == 0)

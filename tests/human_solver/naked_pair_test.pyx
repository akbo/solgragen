from solgragen.human_solver.naked_pair cimport naked_pair
from solgragen.human_solver.utils cimport init_grid
from solgragen.utils import parse_grid


def test_naked_pair():
    cdef char grid[9][9][10]
    init_grid(
        parse_grid(
            "000000012400090000000000054070200000600000400000108000718000000900030700532000000"
        ),
        grid,
    )

    naked_pair(grid)

    assert (grid[7][3][4] == 0) and (grid[7][3][6] == 0)

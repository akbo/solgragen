from solgragen.human_solver.unique cimport unique
from solgragen.human_solver.cleanup cimport cleanup
from solgragen.human_solver.utils cimport init_grid
from solgragen.utils import parse_grid


def test_unique():
    cdef char grid[9][9][10]
    init_grid(
        parse_grid(
            "000000012050400000000000030700600400001000000000080000920700800000510700000003000"
        ),
        grid,
    )

    unique(grid)

    assert grid[6][8][0] == 1

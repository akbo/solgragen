from solgragen.human_solver.hidden_pair cimport hidden_pair
from solgragen.human_solver.utils cimport init_grid
from solgragen.utils import parse_grid


def test_hidden_pair():
    cdef char grid[9][9][10]
    init_grid(
        parse_grid(
            "006000012208031600901062043120576030000204760760300200517000326000620100602100000"
        ),
        grid,
    )

    hidden_pair(grid)

    assert (grid[7][5][5] == 0) and (grid[7][5][8] == 0) and (grid[7][5][9] == 0)

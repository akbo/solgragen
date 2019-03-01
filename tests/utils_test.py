from solgragen.utils import row_coords, col_coords, block_coords


def test_block_coords():
    assert block_coords(5, 5) == [
        (3, 3),
        (3, 4),
        (3, 5),
        (4, 3),
        (4, 4),
        (4, 5),
        (5, 3),
        (5, 4),
    ]


def test_col_coords():
    assert col_coords(5, 5) == [
        (0, 5),
        (1, 5),
        (2, 5),
        (3, 5),
        (4, 5),
        (6, 5),
        (7, 5),
        (8, 5),
    ]


def test_row_coords():
    assert row_coords(5, 5) == [
        (5, 0),
        (5, 1),
        (5, 2),
        (5, 3),
        (5, 4),
        (5, 6),
        (5, 7),
        (5, 8),
    ]


from solgragen.backtrack import backtrack


def test_backtrack():
    assert backtrack(
        [
            [0, 0, 0, 0, 0, 0, 0, 1, 0],
            [4, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 2, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 5, 0, 4, 0, 7],
            [0, 0, 8, 0, 0, 0, 3, 0, 0],
            [0, 0, 1, 3, 9, 8, 6, 2, 5],
            [3, 1, 9, 4, 7, 5, 2, 6, 8],
            [8, 5, 6, 1, 2, 9, 7, 4, 3],
            [2, 7, 4, 8, 3, 6, 1, 5, 9],
        ]
    ) == [
        [
            [6, 9, 3, 7, 8, 4, 5, 1, 2],
            [4, 8, 7, 5, 1, 2, 9, 3, 6],
            [1, 2, 5, 9, 6, 3, 8, 7, 4],
            [9, 3, 2, 6, 5, 1, 4, 8, 7],
            [5, 6, 8, 2, 4, 7, 3, 9, 1],
            [7, 4, 1, 3, 9, 8, 6, 2, 5],
            [3, 1, 9, 4, 7, 5, 2, 6, 8],
            [8, 5, 6, 1, 2, 9, 7, 4, 3],
            [2, 7, 4, 8, 3, 6, 1, 5, 9],
        ]
    ]


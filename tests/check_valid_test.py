from solgragen.utils import parse_grid
from solgragen.check_valid import is_valid_grid


def test_is_valid_grid():
    assert is_valid_grid(parse_grid("2" * 2 + "0" * 79)) == False
    assert (
        is_valid_grid(
            parse_grid(
                "000000010400000000020000000000050407008000300001090000300400200050100000000806000"
            )
        )
        == True
    )

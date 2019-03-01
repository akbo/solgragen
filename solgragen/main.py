from time import time

from solgragen.utils import parse_grid, format_grid
from solgragen.check_valid import is_valid_grid
from solgragen.backtrack import backtrack
from solgragen.human_solver import solve

with open("data/sudoku17.txt") as f:
    grid = f.readlines()[6].strip()

# with open("data/simple_example.txt") as f:
#     grid = f.readlines()[4].strip()

grid = parse_grid(grid)
print(format_grid(grid))
print(is_valid_grid(grid))

# start = time()
# valid_full_grids = backtrack(grid)
# print(f"backtrack took {time() - start} seconds")

# for valid_full_grid in valid_full_grids:
#     print(format_grid(valid_full_grid))

start = time()
human_solution = solve(grid)
print(f"human solver took {time() - start} seconds")
print(format_grid(human_solution))

from setuptools import setup, find_packages
from setuptools.extension import Extension
from Cython.Build import cythonize

extensions = [
    Extension("solgragen.backtrack", ["solgragen/backtrack.pyx"], include_dirs=[]),
    Extension("solgragen.check_valid", ["solgragen/check_valid.pyx"], include_dirs=[]),
    Extension("solgragen.draw_grid", ["solgragen/draw_grid.pyx"], include_dirs=[]),
    Extension(
        "solgragen.human_solver.solver",
        ["solgragen/human_solver/solver.pyx"],
        include_dirs=[],
    ),
    Extension(
        "solgragen.human_solver.cleanup",
        ["solgragen/human_solver/cleanup.pyx"],
        include_dirs=[],
    ),
    Extension(
        "solgragen.human_solver.utils",
        ["solgragen/human_solver/utils.pyx"],
        include_dirs=[],
    ),
    Extension(
        "solgragen.human_solver.naked_single",
        ["solgragen/human_solver/naked_single.pyx"],
        include_dirs=[],
    ),
    Extension(
        "solgragen.human_solver.unique",
        ["solgragen/human_solver/unique.pyx"],
        include_dirs=[],
    ),
    Extension(
        "solgragen.human_solver.naked_pair",
        ["solgragen/human_solver/naked_pair.pyx"],
        include_dirs=[],
    ),
    Extension("solgragen.utils", ["solgragen/utils.pyx"], include_dirs=[]),
    Extension(
        "tests.human_solver.unique_test",
        ["tests/human_solver/unique_test.pyx"],
        include_dirs=[],
    ),
    Extension(
        "tests.human_solver.naked_single_test",
        ["tests/human_solver/naked_single_test.pyx"],
        include_dirs=[],
    ),
]

setup(
    name="solgragen",
    version="0.1.0",
    author="Andreas Bollig",
    author_email="andreas.bollig@gmail.com",
    description="A Cython implementation of a Sudoku solver, grader and generator",
    url="",
    license="MIT",
    packages=find_packages(),
    ext_modules=cythonize(
        extensions,
        compiler_directives={"language_level": 3, "embedsignature": True},
        annotate=True,
    ),
)

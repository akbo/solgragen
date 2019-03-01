from setuptools import setup, find_packages
from setuptools.extension import Extension
from Cython.Build import cythonize

extensions = [
    Extension("solgragen.backtrack", ["solgragen/backtrack.pyx"], include_dirs=[]),
    Extension("solgragen.check_valid", ["solgragen/check_valid.pyx"], include_dirs=[]),
    Extension("solgragen.draw_grid", ["solgragen/draw_grid.pyx"], include_dirs=[]),
    Extension(
        "solgragen.human_solver", ["solgragen/human_solver.pyx"], include_dirs=[]
    ),
    Extension("solgragen.utils", ["solgragen/utils.pyx"], include_dirs=[]),
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
        extensions, compiler_directives={"language_level": 3}, annotate=True
    ),
)


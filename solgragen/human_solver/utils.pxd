cdef void row(int, char[9][2])
cdef void col(int, char[9][2])
cdef void block(int, char[9][2])
cdef int block_idx(int, int)
cdef void set_cell(char[9][9][10], int, int, char)
cdef int grid_full(char[9][9][10])
cdef void values_only(char[9][9][10], char[9][9])
cdef void init_grid(object, char[9][9][10])


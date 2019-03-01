from PIL import Image, ImageDraw, ImageFont
# TODO: print cell indices small into cells

offsets = [
    (0, 0),
    (10, 7),
    (43, 7),
    (76, 7),
    (10, 40),
    (43, 40),
    (76, 40),
    (10, 73),
    (43, 73),
    (76, 73),
]


cdef void draw(char[9][9][10] grid):

    im = Image.new("RGB", (900, 900), color="white")

    draw = ImageDraw.Draw(im)

    # draw gridlines
    for i in range(1, 9):
        if i % 3 == 0:
            width = 5
        else:
            width = 1
        draw.line([(0, i * 100), (900, i * 100)], fill=0, width=width)
        draw.line([(i * 100, 0), (i * 100, 900)], fill=0, width=width)

    smallfnt = ImageFont.truetype("Helvetica", 25)
    bigfnt = ImageFont.truetype("Helvetica", 85)

    for r in range(9):
        for c in range(9):
            if grid[r][c][0]:
                draw.text((c * 100 + 26, r * 100 + 17), str(grid[r][c][0]), font=bigfnt, fill=0)

    for r in range(9):
        for c in range(9):
            for i in range(1, 10):
                if grid[r][c][i]:
                    draw.text(
                        (c * 100 + offsets[i][0], r * 100 + offsets[i][1]),
                        str(i),
                        font=smallfnt,
                        fill=0,
                    )

    im.show()
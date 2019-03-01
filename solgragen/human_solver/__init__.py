from loguru import logger


from solgragen.human_solver.solver import solve


logger.remove()
logger.add("human_solver.log")

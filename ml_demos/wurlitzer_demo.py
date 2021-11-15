import ctypes

libc = ctypes.CDLL(None)

try:
    c_stderr_p = ctypes.c_void_p.in_dll(libc, "stderr")
except ValueError:
    # libc.stdout is has a funny name on OS X
    c_stderr_p = ctypes.c_void_p.in_dll(libc, "__stderrp")


def printf(msg):
    """Call C printf"""
    libc.printf((msg + "\n").encode("utf8"))


def printf_err(msg):
    """Cal C fprintf on stderr"""
    libc.fprintf(c_stderr_p, (msg + "\n").encode("utf8"))


from wurlitzer import pipes, sys_pipes, STDOUT, PIPE

with pipes() as (stdout, stderr):
    printf("Hello, stdout!")
    printf_err("Hello, stderr!")

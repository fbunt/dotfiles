import datetime as dt
import math
import sys


START_STOP_FMT = "START: {start}  >>>  STOP: {stop}"
WALL_FMT = "WALL: {wall}  ({delta})"
OUT_FMT = """\n+{top_div}+
|{start_stop}|
|{wall}|
+{bot_div}+"""
TOP_DIV = (
    "--------------------------------- Time ---------------------------------"
)
BOT_DIV = (
    "------------------------------------------------------------------------"
)


# Taken from ipython's %time magic
# ref: https://github.com/ipython/ipython/blob/main/IPython/core/magics/execution.py
def format_wall(timespan, precision=3):
    """Formats the timespan in a human readable form"""

    if timespan >= 60.0:
        # we have more than a minute, format that in a human readable form
        # Idea from http://snipplr.com/view/5713/
        parts = [("d", 60 * 60 * 24), ("h", 60 * 60), ("min", 60), ("s", 1)]
        time = []
        leftover = timespan
        for suffix, length in parts:
            value = int(leftover / length)
            if value > 0:
                leftover = leftover % length
                time.append("%s%s" % (str(value), suffix))
            if leftover < 1:
                break
        return " ".join(time)

    # Unfortunately the unicode 'micro' symbol can cause problems in
    # certain terminals.
    # See bug: https://bugs.launchpad.net/ipython/+bug/348466
    # Try to prevent crashes by being more secure than it needs to
    # E.g. eclipse is able to print a µ, but has no sys.stdout.encoding set.
    units = ["s", "ms", "us", "ns"]  # the save value
    if hasattr(sys.stdout, "encoding") and sys.stdout.encoding:
        try:
            "\xb5".encode(sys.stdout.encoding)
            units = ["s", "ms", "\xb5s", "ns"]
        except:
            pass
    scaling = [1, 1e3, 1e6, 1e9]

    if timespan > 0.0:
        order = min(-int(math.floor(math.log10(timespan)) // 3), 3)
    else:
        order = 3
    return "%.*g %s" % (precision, timespan * scaling[order], units[order])


class Timer:
    def __init__(self):
        self.tstart = None

    def reset(self, *args, **kwargs):
        self.tstart = dt.datetime.now()

    def stop(self, *args, **kwargs):
        tstop = dt.datetime.now()
        if self.tstart is None:
            return

        delta = tstop - self.tstart
        start_stop_line = START_STOP_FMT.format(start=self.tstart, stop=tstop)
        wall_str = format_wall(delta.total_seconds())
        wall_line = WALL_FMT.format(wall=wall_str, delta=delta)
        n = len(TOP_DIV)
        wall_line += " " * (n - len(wall_line))
        output = OUT_FMT.format(
            top_div=TOP_DIV,
            start_stop=start_stop_line,
            wall=wall_line,
            bot_div=BOT_DIV,
        )
        self.tstart = None
        print(output)


timer = None


def load_ipython_extension(ip):
    global timer
    timer = Timer()
    ip.events.register("pre_run_cell", timer.reset)
    ip.events.register("post_run_cell", timer.stop)


def unload_ipython_extension(ip):
    ip.events.unregister("pre_run_cell", timer.reset)
    ip.events.unregister("post_run_cell", timer.stop)

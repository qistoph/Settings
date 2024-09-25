#!/usr/bin/python3

def interact(_loc):
    ''' Start an interactive debugger
        Attach debugger with `interact(locals())` to access variables in scope
    '''

    import code
    import readline
    import rlcompleter

    vars = globals()
    vars.update(_loc)

    readline.set_completer(rlcompleter.Completer(vars).complete)
    readline.parse_and_bind("tab: complete")
    code.InteractiveConsole(vars).interact()

class measure:
    ''' Context manager to measure execution time

    .. code-block:: python

        with measure("Some Operation") as m:
            some_operation()

        print(m)
        # Some Operation: 0:00:04.526741
    '''

    from datetime import datetime

    def __init__(self, description):
        self.description = description

    def __enter__(self):
        self.t_start = datetime.now()
        return self

    def __exit__(self, typ, value, traceback):
        self.t_end = datetime.now()
        self.duration = self.t_end - self.t_start
        self.exception = (isinstance(value, Exception))

    def __str__(self):
        if self.exception:
            return "Error with '{self.description}' after {self.duration}"
        else:
            return f"{self.description}: {self.duration}"

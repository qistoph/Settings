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

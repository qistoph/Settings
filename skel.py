def interact(_loc):
    import code
    import readline
    import rlcompleter

    vars = globals()
    vars.update(_loc)

    readline.set_completer(rlcompleter.Completer(vars).complete)
    readline.parse_and_bind("tab: complete")
    code.InteractiveConsole(vars).interact()

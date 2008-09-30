def _isIdentifierCharacter(c):
    return ((c == '_') or ('0' <= c <= '9') or ('A' <= c <= 'Z') or ('a' <= c <= 'z'))


class Lexer(object):
    def __init__(my, source):
        my.source = source
        my.i = 0
        my.next()

    def skipWhitespace(my):
        while my.i < len(my.source):
            c = my.source[my.i]
            if ord(c) > 32:
                break
            my.i = my.i + 1

    def next(my):
        my.skipWhitespace()
        if my.i >= len(my.source):
            my.token = None
        else:
            my.token = my.source[my.i]
            if my.token == '_':
                my.lexIdentifier()
            else:
                my.i = my.i + 1

    def lexIdentifier(my):
        i = my.i
        my.i = my.i + 1
        while _isIdentifierCharacter(my.source[my.i]):
            my.i = my.i + 1
        my.token = my.source[i:my.i]


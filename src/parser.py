#!/usr/bin/python


import common
import lexer


class Test(object):
    def __init__(my, name):
        my.name = name

    def __repr__(my):
        return "Test(\"%s\")" % my.name


class Bringup(Test):
    def __init__(my, name, children):
        super(Bringup, my).__init__(name)
        my.children = children

    def childrenRepr(my):
        reps = map(lambda x: x.__repr__(), my.children)
        return ", ".join(reps)

    def __repr__(my):
        return "Bringup(\"%s\", [%s])" % (my.name, my.childrenRepr())


class Setup(Test):
    def __init__(my, name, children):
        super(Setup, my).__init__(name)
        my.children = children

    def childrenRepr(my):
        reps = map(lambda x: x.__repr__(), my.children)
        return ", ".join(reps)

    def __repr__(my):
        return "Setup(\"%s\", [%s])" % (my.name, my.childrenRepr())


def parseUsingLexer(l, tree):
    assert(common.typeOf(l) == "Lexer")
    assert(common.typeOf(tree) == "list")

    while l.token != None:
        length = len(l.token)
        if (length < 6) or (l.token[0:6] != "__CUT_"):
            l.next()
        else:
            if (length > 7) and (l.token[6] == '_'):
                name = l.token[7:]
                l.next()
                if l.token == '(':
                    l.next()
                    tree.append(Test(name))

            elif (length > 16) and (l.token[6:15] == 'BRINGUP__'):
                name = l.token[15:]
                l.next()
                if l.token == '(':
                    l.next()
                    children = []
                    parseUsingLexer(l, children)
                    if l.token[6:16] == 'TAKEDOWN__':
                        name2 = l.token[16:]
                        l.next()
                        if name == name2:
                            tree.append(Bringup(name, children))
                        else:
                            print "ERROR: Expected __CUT_TAKEDOWN__%s, but found __CUT_TAKEDOWN__%s instead." % (name, name2)

            elif (length > 14) and (l.token[6:13] == 'SETUP__'):
                name = l.token[13:]
                l.next()
                if l.token == '(':
                    l.next()
                    children = []
                    parseUsingLexer(l, children)
                    if l.token[6:16] == 'TAKEDOWN__':
                        name2 = l.token[16:]
                        l.next()
                        if name == name2:
                            tree.append(Setup(name, children))
                        else:
                            print "ERROR: Expected __CUT_TAKEDOWN__%s, but found __CUT_TAKEDOWN__%s instead." % (name, name2)

            elif (length > 17) and (l.token[6:16] == 'TAKEDOWN__'):
                return

            else:
                l.next()


def parse(filename, tree):
    assert(common.typeOf(filename) == "str")
    assert(common.typeOf(tree) == "list")

    l = lexer.Lexer(open(filename, "r").read())
    parseUsingLexer(l, tree)


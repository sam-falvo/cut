#!/usr/bin/python


import sys

import common
import lexer
import options as o
import parser


def singleParseTreeFor(files):
    assert(common.typeOf(files) == "list")

    tree = []
    for file in files:
        parser.parse(file, tree)
    return tree


def emitTestRunnerFor(parseTree):
    assert(common.typeOf(parseTree) == "list")  #it's a list of lists

    for node in parseTree:
        node.emitExtern()

    print "\nvoid main(int argc, char *argv[]) {"
    for node in parseTree:
        node.emitCode()
    print "}"


def generateTestRunner(files):
    assert(common.typeOf(files) == "list")
    emitTestRunnerFor(singleParseTreeFor(files))


def main(argv):
    commandName = argv[0]
    args = argv[1:]
    (options, files, errors) = o.collatedArguments(args)
    quickReference = o.usageInformation(commandName)
    versionTag = o.versionInformation(commandName)
    termsAndConditions = o.license(True)
    needToShowHelp = 'help' in options
    needToShowVersion = 'version' in options
    needToShowLicense = 'license' in options

    if needToShowLicense:
        print termsAndConditions
    elif needToShowHelp:
        print quickReference
    elif needToShowVersion:
        print versionTag
    else:
        if len(errors) > 0:
            for error in errors:
                print error
        else:
            generateTestRunner(files)


if __name__ == "__main__":
    main(sys.argv)


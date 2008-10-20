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


def emitTestRunnerFor_to_(parseTree, channel):
    assert(common.typeOf(parseTree) == "list")  #it's a list of lists

    channel.write("#include <stdlib.h>\n")
    channel.write("#include <cut/2.6/cut.h>\n")

    for node in parseTree:
        node.emitExternTo_(channel)

    channel.write("\nint main(int argc, char *argv[]) {\n")
    channel.write("    __cut_assumeDefaults();\n")
    channel.write("    __cut_initializeFromArguments_(argc, argv);\n")

    for node in parseTree:
        node.emitCodeTo_(channel)
    channel.write("    return 0;\n}\n")


def generateTestRunnerFor_to_(files, channel):
    assert(common.typeOf(files) == "list")
    emitTestRunnerFor_to_(singleParseTreeFor(files), channel)


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
    specifiesOutput = 'output' in options

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
            outputChannel = sys.stdout
            if specifiesOutput:
                outputChannel = open(options['output'], "w")

            generateTestRunnerFor_to_(files, outputChannel)


if __name__ == "__main__":
    main(sys.argv)


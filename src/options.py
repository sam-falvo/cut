#!/usr/bin/python


import common


def collatedArguments(args):
    assert(common.typeOf(args) == "list")

    options = []
    files = []
    errors = []

    optionMap = {'h': 'help',
                 '?': 'help',
                 'v': 'version'}

    for a in args:
        if a[0] == '-':
            if len(a) >= 2:
                if a[1] == '-':
                    option = a[2:]
                    if ((option[0:4] == 'help') or
                        (option[0:7] == 'license') or
                        (option[0:7] == 'version')):
                        options.append(option)
                    else:
                        errors.append("\"--%s\": unknown option" % option)
                else:
                    if a[1] in optionMap:
                        options.append(optionMap[a[1]])
                    else:
                        errors.append("\"%s\": unknown option" % a)
            else:
                errors.append("\"-\": option too short")
        else:
            files.append(a)

    return (options, files, errors)


def copyright():
    return "Copyright (c) 1998-2008, Samuel A. Falvo II, William Tanksley Jr."


def license(useLongForm):
    if useLongForm:
        return """%s
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice,
      this list of conditions and the following disclaimer.

    * Redistributions in binary form must reproduce the above copyright notice,
      this list of conditions and the following disclaimer in the documentation
      and/or other materials provided with the distribution.

    * Neither the name of Falvotech, Falvosoft, nor the names of its
      contributors may be used to endorse or promote products derived from this
      software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
""" % copyright()
    else:
        return copyright()


def versionInformation(command):
    return "\n".join([
        "%s 2.6 -- the C Unit-testing Tool" % command,
        license(False),
        "Licensed under BSD terms.  Use --license option to see the full license."
    ])


def usageInformation(command):
    return "\n".join([
        versionInformation(command),
        "",
        "USAGE:  %s [options] {file(s)}" % command,
        "",
        "SHORT    LONG",
        "OPTION   OPTION      DESCRIPTION",
        "---------------------------------------------------------",
        "-h, -?   --help      Prints this quick reference.",
        "         --license   Prints the license for this software.",
        "-v       --version   Prints only the version information.",
        "---------------------------------------------------------",
    ])


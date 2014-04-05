/*
 * cut.h
 * CUT 2.6
 *
 * Copyright (c) 1998, 1999, 2000 Samuel A. Falvo II
 * Copyright (c) 2001 through 2007 Samuel A. Falvo II and others.
 * See LICENSE for details.
 *
 * Based on William D. Tanksley's "TestAssert" package.
 * Based on Samuel A. Falvo II's CUT 1.0 package.
 */

#include <getopt.h>
#include <stdlib.h>
#include <stdio.h>
#include "cut.h"


/** Each assertion that is run by CUT is assigned a number, starting at
 * zero.  This allows the unit test engine to abort program execution at
 * a specific assertion number, if desired.
 */
static unsigned int assertCounter;

/** This value retains the "breakpoint", the assertion number to force
 * termination of unit testing at.
 */
static unsigned int assertionThreshold;

/** Non-zero if verbose mode activated. */
static int isVerbose;


void
__cut_assert(const char *fileName, int lineNumber, const char *message, const char *expression, int value )
{
    if( assertionThreshold != __CUT_NO_BREAKPOINT_SPECIFIED__)
    {
        if(assertCounter >= assertionThreshold)
        {
            fprintf(stderr, "%s:%d:%d: %s: break: %s\n", fileName, lineNumber, assertCounter, expression, message);
            exit(1);
        }
    }

    if(value)
    {
        if(isVerbose) {
            fprintf(stderr, "%s:%d:%d: %s: log: %s\n", fileName, lineNumber, assertCounter, expression, message);
        }

        assertCounter++;
        return;
    }

    fprintf(stderr, "%s:%d:%d: %s: error: %s\n", fileName, lineNumber, assertCounter, expression, message);
    exit(2);
}


void
__cut_assumeDefaults() {
    assertCounter = 0;
    assertionThreshold = __CUT_NO_BREAKPOINT_SPECIFIED__;
    isVerbose = 0;
}

void 
__cut_initializeFromArguments_(int argc, char *argv[]) {
    static struct option opts[] = {
        {"break-at", required_argument, NULL,       'b'},
        {"verbose",  no_argument,       &isVerbose, 1},
        {0,          0,                 NULL,       0}
    };
    int unused = 0;
    int c;

    do {
        c = getopt_long(argc, argv, "b:v", opts, &unused);
        if(c > -1) {
            switch(c) {
            case 0:
                /* Ignore flag-setting long options; they're handled automatically for us. */
                break;

            case 'b':
                assertionThreshold = atoi(optarg);
                break;

            case 'v':
                isVerbose = 1;
                break;

            default:
                fprintf(stderr, "Ignoring option -%c\n", c);
                break;
            }
        }
    } while(c != -1);
}


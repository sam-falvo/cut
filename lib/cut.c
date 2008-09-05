/*
 * cut.h
 * CUT 3.0
 *
 * Copyright (c) 1998, 1999, 2000 Samuel A. Falvo II
 * Copyright (c) 2001 through 2007 Samuel A. Falvo II and others.
 * See LICENSE for details.
 *
 * Based on William D. Tanksley's "TestAssert" package.
 * Based on Samuel A. Falvo II's CUT 1.0 package.
 */

#include <stdlib.h>
#include <stdio.h>
#include <cut/3/cut.h>


/** Each assertion that is run by CUT is assigned a number, starting at
 * zero.  This allows the unit test engine to abort program execution at
 * a specific assertion number, if desired.
 */
static unsigned int assertCounter;

/** This value retains the "breakpoint", the assertion number to force
 * termination of unit testing at.
 */
static unsigned int assertionThreshold;


void
__cut_assert(char *fileName, int lineNumber, char *message, char *expression, int value )
{
    if( assertionThreshold != __CUT_NO_BREAKPOINT_SPECIFIED__)
    {
        if(assertCounter >= assertionThreshold)
        {
            fprintf(stderr, "%s:%d:%s:Test breakpoint reached.\n", fileName, lineNumber, expression);
            exit(1);
        }
    }

    if(value)
    {
        assertCounter++;
        return;
    }

    fprintf(stderr, "%s:%d:%s:%s\n", fileName, lineNumber, expression, message);
    exit(2);
}


void 
__cut_init(unsigned int breakPointAt) 
{
    assertCounter = 0;
    assertionThreshold = breakPointAt;
}


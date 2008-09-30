#ifndef CUT_2_6_CUT_H
#define CUT_2_6_CUT_H

/*
 * cut.h
 * CUT 2.6
 *
 * Copyright (c) 1998, 1999, 2000 Samuel A. Falvo II
 * Copyright (c) 2001 through 2008 Samuel A. Falvo II and others.
 * See LICENSE for details.
 *
 * Based on William D. Tanksley's "TestAssert" package.
 * Based on Samuel A. Falvo II's CUT 1.0 package.
 */

#define ASSERT(X,msg)   __cut_assert(__FILE__,__LINE__,msg,#X,X)
#define ASSERT_(X)      __cut_assert(__FILE__,__LINE__,"",#X,X)

#define STATIC_ASSERT(X)         \
    extern bool __static_ASSERT_at_line_##__LINE__##__[ (0!=(X))*2-1 ];

/*
 * These functions are not officially "public".  They exist here because they
 * need to be for proper operation of CUT.  Please use the aforementioned
 * macros instead.
 */

void __cut_assert       ( char *, int, char *, char *, int );
void __cut_init         ( unsigned int );
#define __CUT_NO_BREAKPOINT_SPECIFIED__ ((unsigned int)((int)(-1)))

#endif


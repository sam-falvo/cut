#include <stdio.h>

void __CUT__Testing1(void) { blah(); }

void
__CUT__Testing2





                (                                                                 void
) { blah(); }

/* We don't want either __CUT__Testing1 or __CUT__Testing2 to appear in any cutgen output when not in a proper procedure declaration. */


void __CUT_BRINGUP__B1(void) { }
void __CUT__muffy(void) {}
void __CUT_TAKEDOWN__B1(void) {}


void __CUT_BRINGUP__B2(void) {}
  void __CUT__doh(void) {}
  void __CUT__narf(void) {}
  void __CUT_BRINGUP__B2A(void) {}
    void __CUT__T1(void) {}
    void __CUT__T2(void) {}
    void __CUT__T3(void) {}
  void __CUT_TAKEDOWN__B2A(void) {}
  void __CUT_BRINGUP__B2B(void) {}
    void __CUT__T4(void) {}
      void __CUT_SETUP__B2BA(void) {}
        void __CUT__T7(void) {}
        void __CUT__T8(void) {}
      void __CUT_TAKEDOWN__B2BA(void) {}
    void __CUT__T5(void) {}
    void __CUT__T6(void) {}
  void __CUT_TAKEDOWN__B2B(void) {}
void __CUT_TAKEDOWN__B2(void) {}
void __CUT__yiffy(void) {}


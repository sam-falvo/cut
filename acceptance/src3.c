static int x;

void __CUT_SETUP__Foo(void) {
    x = 0;
}

void __CUT__shouldIncrementByOne(void) {
    x++;
    ASSERT(x == 1);
}

void __CUT__shouldIncrementByFive(void) {
    x+=5;
    ASSERT(x==5);
}

void __CUT_TAKEDOWN__Foo(void) {}

void __CUT_SETUP__Bar(void) {
    x = 100;
}

void __CUT__shouldDecrementByOne(void) {
    x--;
    ASSERT(x==99);
}

void __CUT__shouldDecrementByFive(void) {
    x -= 5;
    ASSERT(x==95);
}

void __CUT_TAKEDOWN__Bar(void) {}

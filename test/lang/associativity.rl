::rl::lang::associativity
{
	TEST "assignment" {
		a ::= 5;
		b ::= 4;
		c ::= 3;
		a := b := c;
		ASSERT(a == 3);
		ASSERT(b == 3);
		ASSERT(c == 3);
	}
	TEST "div" {
		ASSERT(1000 / 10 / 10 == 10);
	}
	TEST "sub" {
		ASSERT(1 - 1 - 1 == -1);
	}
}
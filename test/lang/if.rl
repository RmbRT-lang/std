::lang::if
{
	TEST "expression if"
	{
		c ::= TRUE;
		x ::= FALSE;
		IF(c) x := TRUE; ELSE DIE;
		ASSERT(x);

		c := FALSE;
		IF(c) DIE;
	}

	TEST "negated if"
	{
		c ::= FALSE;
		x ::= FALSE;
		IF!(c) x := TRUE; ELSE DIE;
		ASSERT(x);

		c := TRUE;
		IF!(c) DIE;
	}

	TEST "variable if"
	{
		IF(c ::= TRUE) { ASSERT(c); } ELSE DIE;
		IF(c ::= FALSE) DIE; ELSE ASSERT(!c);
	}

	TEST "negated variable if"
	{
		IF!(c ::= TRUE) DIE; ELSE ASSERT(c);
		IF!(c ::= FALSE) ASSERT(!c); ELSE DIE;
	}

	TEST "expose variable"
	{
		IF: [if_label] !(c ::= TRUE) DIE;

		ASSERT(c);
	}
}
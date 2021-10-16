::lang::enum
{
	ENUM E { a, b, c }

	TEST "symbolic enum"
	{
		x: E;
		x := :a;
		ASSERT(x == E::a);
		x := :b;
		ASSERT(x == E::b);
		ASSERT(x != :a);
	}

	TEST "switch symbol constant"
	{
		SWITCH(E::a)
		{
		:b: ASSERT(FALSE);
		:a: {;}
		DEFAULT: ASSERT(FALSE);
		}
	}
	TEST "switch symbol constant variable"
	{
		SWITCH(x ::= E::a)
		{
		:a: {;}
		DEFAULT:
			ASSERT(FALSE);
		}
	}
}
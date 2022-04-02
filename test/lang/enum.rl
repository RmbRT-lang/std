::lang::enum
{
	ENUM E { a, b, c }

	TEST "symbolic enum"
	{
		x: E := :a;
		ASSERT(x == E::a);
		x := :b;
		ASSERT(x == E::b);
		ASSERT(x != :a);
	}

	TEST "switch symbol constant"
	{
		SWITCH(E::a)
		{
		:b: DIE;
		:a: {;}
		DEFAULT: DIE;
		}
	}
	TEST "switch symbol constant variable"
	{
		SWITCH(x ::= E::a)
		{
		:a: {;}
		DEFAULT:
			DIE;
		}
	}
}
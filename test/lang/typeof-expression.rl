INCLUDE 'std/string'

::rl::lang::typeof
{
	Base VIRTUAL {}
	Derived -> Base {}

	TEST "TYPE TYPE: native types"
	{
		ASSERT(!std::str::cmp(TYPE TYPE(S1), "S1"));
		ASSERT(!std::str::cmp(TYPE TYPE(U1), "U1"));
		ASSERT(!std::str::cmp(TYPE TYPE(S2), "S2"));
		ASSERT(!std::str::cmp(TYPE TYPE(U2), "U2"));
		ASSERT(!std::str::cmp(TYPE TYPE(S4), "S4"));
		ASSERT(!std::str::cmp(TYPE TYPE(U4), "U4"));
		ASSERT(!std::str::cmp(TYPE TYPE(S8), "S8"));
		ASSERT(!std::str::cmp(TYPE TYPE(U8), "U8"));
		ASSERT(!std::str::cmp(TYPE TYPE(BOOL), "BOOL"));
	}

	TEST "TYPE TYPE: classes"
	{
		ASSERT(!std::str::cmp(TYPE TYPE(Base), "rl::lang::typeof::Base"));
		ASSERT(!std::str::cmp(TYPE TYPE(Derived), "rl::lang::typeof::Derived"));
	}


	TEST "TYPE STATIC"
	{
		ASSERT(TYPE STATIC(1) == TYPE TYPE(INT));
		d: Derived;
		b: Base & := d;
		ASSERT(TYPE STATIC(b) == TYPE TYPE(Base));
	}


	TEST "TYPE"
	{
		ASSERT(TYPE(1) == TYPE TYPE(INT));
		d: Derived;
		b: Base & := d;
		ASSERT(TYPE(b) == TYPE TYPE(Derived));
	}
}
::rl::lang::assign
{
	Class
	{
		MovedOut: BOOL;
		MovedIn: BOOL;
		Destroyed: BOOL;

		{};

		{&&m}: MovedIn(TRUE), Destroyed(NOINIT)
		{ m.MovedOut := TRUE; }

		DESTRUCTOR { Destroyed := TRUE; }
	}

	TEST "move assignment"
	{
		x: Class;
		y: Class;

		ASSERT(!x.Destroyed);
		x := &&y;

		ASSERT(x.MovedIn);
		ASSERT(y.MovedOut);
		ASSERT(x.Destroyed);
	}
}
::rl::lang::assign
{
	Class
	{
		MovedOut: BOOL;
		MovedIn: BOOL;
		STATIC Destroyed: BOOL;

		{};

		{&&m}: MovedIn(TRUE)
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
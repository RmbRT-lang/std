::lang::tuple
{
	Class
	{
		A: INT;
		B: INT;

		{a: INT, b: INT}: A(a), B(b);
		{};

		# THIS==(rhs: Class#&) INLINE BOOL := A == rhs.A && B == rhs.B;
		# THIS!=(rhs: Class#&) INLINE BOOL := !(THIS == rhs);

		# <{INT, INT}> := (A, B);
	}

	f(c: Class#&) ::= c;

	TEST "tuple expressions"
	{
		ASSERT(<Class>((1,2)) == <Class>(1,2));
		ASSERT(<Class>(3,4) != (5,6));
		ASSERT(f((1,2)) == (1,2));

		STATIC a: Class#[] ((1,2), (3,4), (5,6));
		ASSERT(a[0] == (1,2));
		ASSERT(a[1] == (3,4));
		ASSERT(a[2] == (5,6));
		ASSERT(<{INT, INT}>(a[0]) == (1,2));
	}

	Num {
		V: INT;

		{}: V(0);
		{v: INT}: V(v);

		# THIS/(rhs: INT) ::= V/rhs;
		# THIS%(rhs: INT) ::= V%rhs;
		# THIS/(rhs: {:divmod, INT}) ::= (V/rhs.(1), V%rhs.(1));
	}

	TEST "tuple arguments and returns"
	{
		ASSERT(Num(14) / (:divmod, 5) == (2, 4));
	}

	PointI
	{
		X: INT;
		Y: INT;

		{};
		{x: INT, y: INT}: X(x), Y(y);

		# <{float, float}> := (X, Y);
	}

	PointF
	{
		X: float;
		Y: float;
		
		{};
		{x: float, y: float}: X(x), Y(y);

		# <{INT, INT}> := (X, Y);
	}

	TEST "structural conversion"
	{
		i: PointI;
		f: PointF;

		i := <{INT, INT}>(f);
		f := <{float, float}>(i);
		x: INT;
		y: INT;
		(x,y) := <{INT, INT}>(f);
	}
}
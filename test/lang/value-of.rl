::rl::lang::value_of
{
	[T:TYPE] Wrap
	{
		v: T!;

		{};
		{v: T!}: v(v);

		//# THIS! & INLINE ::= v;
		THIS! & INLINE ::= v;
	}

	TEST "recursive unwrap"
	{
		x: INT - Wrap - Wrap;

		ASSERT(TYPE(x!) == TYPE TYPE(INT));
		x! := 5;
		ASSERT(x! == 5);
		ASSERT(++x! == 6);
	}


	[T: TYPE]
	RefWrap
	{
		v: T\;
		{r: T&}: v(&r);
		THIS! T& := *v;
	}

	[T: TYPE]
	TempValueOf
	{
		v: T;
		{v: T}: v(v);
		THIS! T-RefWrap INLINE := v;
	}
	TEST "correct temporary values"
	{
		x: INT-TempValueOf(2);
		y: INT & := x!;
		y := 4;
		ASSERT(x.v == 4);
		ASSERT(&y == &x.v);
		x! := 5;
		ASSERT(x! == 5);
	}

	TEST "move reference"
	{
		a ::= 5;
		x:? && := &&a;
		y:? && := x!;
		ASSERT(&y == &x);
	}

	TEST "default unwrap returns reference"
	{
		x: INT(0);
		vx: ?& := x!;
		ASSERT(&x == &vx);
	}
}

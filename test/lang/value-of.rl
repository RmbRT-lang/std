::rl::lang::value_of
{
	[T:TYPE] Wrap
	{
		v: T;
		# THIS! INLINE & ::= v;
		THIS! INLINE & ::= v;
	}

	TEST "recursive unwrap"
	{
		x: INT - Wrap - Wrap;

		ASSERT(TYPE(x!) == TYPE TYPE(INT));
		x! := 5;
		ASSERT(x! == 5);
		ASSERT(++x! == 6);
	}

	TEST "default unwrap returns reference"
	{
		x: INT(0);
		ASSERT(&x == &x!);
	}
}

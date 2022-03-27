INCLUDE 'std/optional'

::std::opt_test
{
	TYPE Assertion := CHAR #\;

	TEST "construction"
	{
		x: INT-Opt;
		ASSERT(!x);

		ok: BOOL;
		TRY { x!; ok := TRUE; } CATCH(Assertion){}
		ASSERT(!ok);

		x := :some(5);
		ASSERT(x);
		ASSERT(x! == 5);

		x! := 0;
		ASSERT(x);
		ASSERT(!x!);

		y ::= &&x;
		ASSERT(y);
		ASSERT(x);
		ASSERT(!y!);
		ASSERT(!x!);

		y := NULL;
		ASSERT(!y);
	}
}
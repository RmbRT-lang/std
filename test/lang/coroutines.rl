::lang
{
	F
	{
		lel() @INT := 5;
	}

	testfn() @ VOID
	{
		f: F;
		h ::= f.lel();
		ASSERT(5 == <-h);
		RETURN;
	}

	TEST "await"
	{
		testfn().get();
	}
}
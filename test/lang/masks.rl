::lang
{
	MASK Testable { # test() BOOL; }

	Fail { # test() BOOL := FALSE; }
	Success { # test() BOOL := TRUE; }
	Other { #test() INT := 5; }

	TEST "FROM"
	{
		f: Fail;
		ASSERT(!<<<Testable>>>(f).test());
		ASSERT(!<<<Testable>>>(&f).test());
		s: Success;
		ASSERT(<<<Testable>>>(s).test());
		ASSERT(<<<Testable>>>(&s).test());
		o: Other;
		ASSERT(<<<Testable>>>(o).test());
	}
}
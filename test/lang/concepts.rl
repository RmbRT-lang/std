::lang
{
	CONCEPT Testable { # test() BOOL; }

	Fail { # test() BOOL := FALSE; }
	Success { # test() BOOL := TRUE; }

	TEST "FROM"
	{
		f: Fail;
		ASSERT(!<<<Testable>>>(f).test());
		ASSERT(!<<<Testable>>>(&f).test());
		s: Success;
		ASSERT(<<<Testable>>>(s).test());
		ASSERT(<<<Testable>>>(&s).test());
	}
}
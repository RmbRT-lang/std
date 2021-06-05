INCLUDE "../std/memory"

::std
{
	TEST "memcmp"
	{
		ASSERT(memcmp("aaa", "aab", 3) < 0);
		buf: CHAR[3](<CHAR>(0xe2), <CHAR>(0x82), <CHAR>(0xac));
		ASSERT(memcmp("€", buf, 3) == 0);
	}

	NewException{
		{calls: INT \}: DtorCalled(calls) { THROW; }
		DESTRUCTOR { ++*DtorCalled; }
		DtorCalled: INT \;
	}
	TEST "new with exception only calls dtor once" {
		calls: INT (0);
		TRY [NewException]new(&calls);
		CATCH() {;}
		ASSERT(calls == 1);
	}
}
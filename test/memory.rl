INCLUDE "../std/memory"

::std
{
	TEST "memcmp"
	{
		ASSERT(memcmp("aaa", "aab", 3) < 0);
		buf: CHAR[3](<CHAR>(0xe2), <CHAR>(0x82), <CHAR>(0xac));
		ASSERT(memcmp("€", buf, 3) == 0);
	}


	DtorTracker {
		{calls: INT\}: DtorCalled(calls);
		DESTRUCTOR{++*DtorCalled;}
		DtorCalled: INT \;
	}

	NewException
	{
		Member: DtorTracker;
		MainDtorCalled: BOOL \;

		{main: BOOL \, member: INT \}:
			Member(member),
			MainDtorCalled(main)
		{ THROW; }

		DESTRUCTOR{*MainDtorCalled := TRUE;}
	}

	TEST "new with exception only calls dtor once" {
		mainDtor ::= FALSE;
		calls: INT (0);

		TRY [NewException]new(&mainDtor, &calls);
		CATCH() {;}
		ASSERT(calls == 1);
		ASSERT(!mainDtor);
	}
}
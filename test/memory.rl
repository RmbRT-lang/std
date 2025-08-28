INCLUDE "../std/memory"

::std
{
	TEST "memcmp"
	{
		a: INT[?] (1, 2, 3);
		b: INT[?] (1, 2, 2);

		ASSERT(mem::[INT]cmp(a[], b[], ##a) > 0);

		ASSERT(mem::cmp("aaa"[], "aab"[], 3) < 0);
		buf: CHAR#[3](<CHAR>(0xe2), <CHAR>(0x82), <CHAR>(0xac));
		ASSERT(mem::cmp("€"[], buf[], 3) == 0);
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

		TRY heap::alloc.[NewException]new(&mainDtor, &calls);
		CATCH() {;}
		ASSERT(calls == 1);
		ASSERT(!mainDtor);
	}


	NewBase1 VIRTUAL { INT; }
	NewBase2 VIRTUAL { INT; }
	NewDerived1 VIRTUAL -> NewBase1 { INT; }
	NewDerived -> NewBase2, NewDerived1 { INT; }

	(/ Virtual inheritance is garbage anyway.

	TEST "new and delete with polymorphism"
	{
		ptr ::= heap::alloc.[NewDerived]new();
		ASSERT(ptr != NULL);
		ASSERT(<<NewBase1 *>>(ptr) > <VOID*>(ptr));
		ASSERT(&&&*<<NewBase1 *>>(ptr) == <VOID*>(ptr));

		heap::alloc.delete(<<NewBase1 \>>(ptr));
	}/)
}
INCLUDE "../std/memory"

::std
{
	TEST "memcmp"
	{
		ASSERT(mem::cmp("aaa", "aab", 3) < 0);
		buf: CHAR[3](<CHAR>(0xe2), <CHAR>(0x82), <CHAR>(0xac));
		ASSERT(mem::cmp("€", buf!, 3) == 0);
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

		TRY heap::[NewException]new(&mainDtor, &calls);
		CATCH() {;}
		ASSERT(calls == 1);
		ASSERT(!mainDtor);
	}


	NewBase1 VIRTUAL { INT; }
	NewBase2 VIRTUAL { INT; }
	NewDerived1 VIRTUAL -> NewBase1 { INT; }
	NewDerived -> NewBase2, NewDerived1 { INT; }

	TEST "new and delete with polymorphism"
	{
		ptr ::= heap::[NewDerived]new();
		ASSERT(ptr != NULL);
		ASSERT(<<NewBase1 *>>(ptr) > <VOID*>(ptr));
		ASSERT(&&&*<<NewBase1 *>>(ptr) == <VOID*>(ptr));

		heap::delete(<<NewBase1 \>>(ptr));
	}

	TEST "dynamic :a() ctor"
	{
		x: INT-DynOpt := :a(5);
		ASSERT(x);
		ASSERT(*x == 5);
	}

	Animal VIRTUAL {}
	Cow -> Animal  {}

	TEST "polymorphic :a.T() ctor"
	{
		cattle: Animal-std::Dyn := :a.Cow();
		ASSERT(cattle);
		ASSERT(TYPE(*cattle) == TYPE TYPE(Cow));
	}

	TEST "dynamic <> operator"
	{
		a: INT- std::Dyn := 5;
		b: INT := 6;
		c: INT := 5;
	
		ASSERT((a <> &b) < 0);
		ASSERT((a <> &c) == 0);
	}
}
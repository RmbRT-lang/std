INCLUDE 'std/optional'

::std::opt_test
{
	TYPE Assertion := CHAR #\;

	TrackedCtor {
		STATIC CtorCalled: BOOL := FALSE;
		STATIC BareCalled: BOOL := FALSE;
		{} { CtorCalled := TRUE; }
		{BARE} { BareCalled := TRUE; }
	}

	TestStruct {
		A: INT;
		B: INT;
		C: CHAR #\ -Opt;
	}

	TEST "construction"
	{
		<[TrackedCtor]Opt>();
		ASSERT(!TrackedCtor::CtorCalled);
		<[TrackedCtor]Opt>(:a);
		ASSERT(TrackedCtor::CtorCalled);

		x: INT-Opt;
		ASSERT(!x);

		ok: BOOL;
		TRY { x!; ok := TRUE; } CATCH(Assertion){}
		ASSERT(!ok);

		x := :a(5);
		ASSERT(x);
		ASSERT(x! == 5);

		x! := 0;
		ASSERT(x);
		ASSERT(!x!);

		y ::= &&x;
		ASSERT(y);
		ASSERT(!x);
		ASSERT(!y!);

		y := NULL;
		ASSERT(!y);

		a: TestStruct (5, 6, :a("hello"));
		b: TestStruct := a;


		ASSERT(!TrackedCtor::BareCalled);
		TrackedCtor::CtorCalled := FALSE;
		<[TrackedCtor]Opt>(:a(BARE));
		ASSERT(!TrackedCtor::CtorCalled);
		ASSERT(TrackedCtor::BareCalled);
	}


	NeverDestruct { STATIC Dtor: BOOL := FALSE; DESTRUCTOR { Dtor := TRUE; } }

	TrackedDtor { STATIC Dtor: BOOL; DESTRUCTOR { Dtor := TRUE; } }

	TEST "destructor"
	{
		{ x: NeverDestruct-Opt; }
		ASSERT(!NeverDestruct::Dtor);
		v: TrackedDtor-Opt := :a();
		v.~;
		ASSERT(v->Dtor);
	}
}
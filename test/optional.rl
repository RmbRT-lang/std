INCLUDE 'std/optional'

::std::opt_test
{
	TYPE Assertion := CHAR #\;

	TrackedCtor {
		STATIC CtorCalled: BOOL := FALSE;
		{} { CtorCalled := TRUE; }
	}

	TEST "construction"
	{
		<[TrackedCtor]Opt>();
		ASSERT(!TrackedCtor::CtorCalled);

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
	}


	NeverDestruct { STATIC Dtor: BOOL := FALSE; DESTRUCTOR { Dtor := TRUE; } }

	TrackedDtor { Dtor: BOOL; DESTRUCTOR { Dtor := TRUE; } }

	TEST "destructor"
	{
		{ x: NeverDestruct-Opt; }
		ASSERT(!NeverDestruct::Dtor);
		v: TrackedDtor-Opt := :a();
		v.~;
		ASSERT(v->Dtor);
	}
}
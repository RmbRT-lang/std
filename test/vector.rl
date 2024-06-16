INCLUDE "../std/vector"

::std
{
	TEST "emplace"
	{
		v: {INT, INT}-Vec := :vec((0,1), (2,3), (4,5));
		ASSERT(##v == 3);
		ASSERT(v[0] == (0,1));
		ASSERT(v[1] == (2,3));
		ASSERT(v[2] == (4,5));

		v.emplace_at(1, (6,7));
		ASSERT(##v == 4);
		ASSERT(v[0] == (0,1));
		ASSERT(v[1] == (6,7));
		ASSERT(v[2] == (2,3));
		ASSERT(v[3] == (4,5));
	}

	TEST "bare ctor"
	{
		v: INT-Vec(BARE);
		ASSERT(!##v);
		ASSERT(!v.data());
	}

	TEST "copy"
	{
		v: INT-Vec #:= :vec(1,2,3,4,5);
		v2: INT := v;
		v2 := v;
	}
}
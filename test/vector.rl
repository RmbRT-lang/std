INCLUDE "../std/vector"

::std
{
	TEST "emplace"
	{
		v: {INT, INT}-Vector(:emplace, (0,1), (2,3), (4,5));
		ASSERT(##v == 3);
		ASSERT(v[0] == (0,1));
		ASSERT(v[1] == (2,3));
		ASSERT(v[2] == (4,5));

		v.emplace(1, (6,7));
		ASSERT(##v == 4);
		ASSERT(v[0] == (0,1));
		ASSERT(v[1] == (6,7));
		ASSERT(v[2] == (2,3));
		ASSERT(v[3] == (4,5));
	}
}
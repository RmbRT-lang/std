INCLUDE 'std/memory'

::lang::visit
{
	Struct
	{
		Member1: INT;
		B: INT;
	}

	visit(name: CHAR #\, value: INT, out: {CHAR #\, INT}-std::Buffer, index: INT &) VOID
	{
		out[index++] := (name, value);
	}

	TEST "visit"
	{
		result: {CHAR #\, INT}[2]((NULL, 0), (NULL, 0));
		index: INT := 0;

		x: Struct;
		x.Member1 := 1;
		x.B := 5;
		visit VISIT*(x, (result!, ##result), index);

		ASSERT(index == 2);
		ASSERT(std::str::view(result[0].(0)) == "Member1");
		ASSERT(result[0].(1) == 1);
		ASSERT(std::str::view(result[1].(0)) == "B");
		ASSERT(result[1].(1) == 5);
	}
}
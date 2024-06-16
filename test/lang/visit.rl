INCLUDE 'std/memory'
INCLUDE 'std/optional'
INCLUDE 'std/range'

::lang::visit
{
	Base {}
	Struct -> Base
	{
		Member1: INT;
		B: INT;
	}

	Visitor
	{
		[T: TYPE] THIS(
			name: CHAR #\,
			value: T! #&,
			out: {CHAR #\, INT-std::Opt}-std::Buffer,
			index: INT &
		) VOID
		{
			TYPE SWITCH STATIC(value)
			{
			INT: out[index++] := (name, :a(value));
			DEFAULT: out[index++] := (name, NULL);
			}
		}
	}

	TEST "visit"
	{
		result: {CHAR #\, INT-std::Opt}[3] (NOINIT);
		FOR(it ::= std::range::start(result))
			it!.{};

		index: INT := 0;

		x: Struct;
		x.Member1 := 1;
		x.B := 5;
		visit: Visitor;
		visit VISIT*(x, (result!, ##result), index);

		ASSERT(index == ##result);
		ASSERT(std::str::view(result[0].(0)) == "lang::visit::Base");
		ASSERT(!result[0].(1));
		ASSERT(std::str::view(result[1].(0)) == "Member1");
		ASSERT(result[1].(1));
		ASSERT(result[1].(1)! == 1);
		ASSERT(std::str::view(result[2].(0)) == "B");
		ASSERT(result[2].(1));
		ASSERT(result[2].(1)! == 5);
	}

	copy_into_array(i: INT, v: INT, out: INT *) VOID
	{ out[i] := v; }

	TEST "reflect visit tuple"
	{
		dst: INT[3];

		copy_into_array VISIT* ((1,2,3), &dst[0]);
		FOR(x ::= std::range::start(dst))
			ASSERT(x! == x() +1);
	}

	copy_into_array_iter(v: INT, out: INT **) VOID
	{ *(*out)++ := v; }

	TEST "visit tuple"
	{
		dst: INT[3];
		it ::= &dst[0];
		copy_into_array_iter VISIT ((1,2,3), &it);

		FOR(x ::= std::range::start(dst))
			ASSERT(x! == x() +1);
	}
}
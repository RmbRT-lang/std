INCLUDE 'std/buffer'

::test::lang::range_for {
	TEST "range for" {
		STATIC arr: INT#[] (0, 1, 2, 3, 4);
		b: std::Buffer(arr, ##arr);
		counter ::= 0;
		FOR(it ::= b.start())
		{
			ASSERT(it! == counter);
			++counter;
		}
		ASSERT(counter == ##arr);
	}

	TEST "anonymous range for" {
		STATIC arr: INT#[] (0, 1, 2, 3, 4);
		b: std::Buffer(arr, ##arr);
		counter ::= 0;
		FOR(b.start())
			++counter;
		ASSERT(counter == ##arr);
	}

	TEST "reverse range for" {
		STATIC arr: INT#[] (0, 1, 2, 3, 4);
		b: std::Buffer(arr, ##arr);
		counter ::= ##arr;
		FOR(it ::= b.end(); --)
		{
			--counter;
			ASSERT(it! == counter);
		}
		ASSERT(counter == 0);
	}

	TEST "anonymous reverse range for" {
		STATIC arr: INT#[] (0, 1, 2, 3, 4);
		b: std::Buffer(arr, ##arr);
		counter ::= ##arr;
		FOR(b.end(); --)
			--counter;
		ASSERT(counter == 0);
	}
}
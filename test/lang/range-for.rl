//INCLUDE 'std/buffer'

::test::lang::range_for {
	(/TEST "range for" {
		STATIC arr: INT#[?] (3, 4, 5, 6, 7);
		counter ::= 0;
		FOR(it ::= arr)
		{
			ASSERT(it! == counter+3);
			ASSERT(it() == counter);
			++counter;
		}
		ASSERT(counter == ##arr);
	}/)

	TEST "anonymous range for" {
		STATIC arr: INT#[?] (3, 4, 5, 6, 7);
		counter ::= 0;
		FOR(arr)
		{
			ASSERT(IOTA == counter);
			ASSERT(IOTA! == counter);
			ASSERT(ITER! == counter+3);
			ASSERT(ITER() == counter);
			ASSERT(&*ITER == &arr[counter]);
			ASSERT(&IT == &arr[counter]);
			++counter;
		}
		ASSERT(counter == ##arr);
	}

	(/TEST "reverse range for: array" {
		STATIC arr: INT#[?] (3, 4, 5, 6, 7);
		counter ::= ##arr;
		FOR(it ::= arr; --)
		{
			--counter;
			ASSERT(it! == counter + 3);
			ASSERT(it() == counter);
			ASSERT(&*it == &arr[counter]); // ensure no copy happens.
		}
		ASSERT(counter == 0);
	}
	TEST "reverse range for: T[#]" {
		STATIC arr: INT#[?] (3, 4, 5, 6, 7);
		counter ::= ##arr;
		FOR(it ::= arr[#]; --)
		{
			--counter;
			ASSERT(it! == counter + 3);
			ASSERT(it() == counter);
			ASSERT(&*it == &arr[counter]); // ensure no copy happens.
		}
		ASSERT(counter == 0);
	}

	TEST "reverse range for: T[#] &" {
		STATIC arr: INT#[?] (3, 4, 5, 6, 7);
		counter ::= ##arr;
		slice ::= arr[#];
		FOR(it ::= slice; --)
		{
			--counter;
			ASSERT(it! == counter + 3);
			ASSERT(it() == counter);
			ASSERT(&*it == &arr[counter]); // ensure no copy happens.
		}
		ASSERT(counter == 0);
	}

	TEST "reverse range for: T[#] #&" {
		STATIC arr: INT#[?] (3, 4, 5, 6, 7);
		counter ::= ##arr;
		slice #::= arr[#];
		FOR(it ::= slice; --)
		{
			--counter;
			ASSERT(it! == counter + 3);
			ASSERT(it() == counter);
			ASSERT(&*it == &arr[counter]); // ensure no copy happens.
		}
		ASSERT(counter == 0);
	}

	TEST "reverse range for: T[#] #&&" {
		STATIC arr: INT#[?] (3, 4, 5, 6, 7);
		counter ::= ##arr;
		slice #::= arr[#];
		FOR(it ::= &&slice; --)
		{
			--counter;
			ASSERT(it! == counter + 3);
			ASSERT(it() == counter);
			ASSERT(&*it == &arr[counter]); // ensure no copy happens.
		}
		ASSERT(counter == 0);
	}

	TEST "reverse range for: T[#] &&" {
		STATIC arr: INT#[?] (3, 4, 5, 6, 7);
		counter ::= ##arr;
		slice ::= arr[#];
		FOR(it ::= &&slice; --)
		{
			--counter;
			ASSERT(it! == counter + 3);
			ASSERT(it() == counter);
			ASSERT(&*it == &arr[counter]); // ensure no copy happens.
		}
		ASSERT(counter == 0);
	}/)

	TEST "anonymous reverse range for" {
		STATIC arr: INT#[?] (3, 4, 5, 6, 7);
		counter ::= ##arr;
		FOR(arr; --)
		{
			--counter;
			ASSERT(IOTA == counter);
			ASSERT(ITER! == counter+3);
			ASSERT(ITER() == counter);
			ASSERT(&*ITER == &arr[counter]);
			ASSERT(&IT == &arr[counter]);
			ASSERT(IT == arr[counter]);
		}
		ASSERT(counter == 0);
	}

	TEST "anonymous number range for" {
		counter ::= 0;
		FOR(5) {
			ASSERT(IOTA == counter);
			ASSERT(IOTA! == counter);
			ASSERT(ITER! == counter);
			ASSERT(ITER() == counter);
			++counter;
		}
		ASSERT(counter == 5);
	}

	TEST "anonymous number range for: reverse" {
		counter ::= 5;
		FOR(5; --) {
			--counter;
			ASSERT(IOTA == IT);
			ASSERT(IOTA! == counter);
			ASSERT(ITER() == counter);
			ASSERT(*ITER == counter);
		}
		ASSERT(counter == 0);
	}

	(/TEST "number range for" {
		counter ::= 0;
		FOR(i ::= 5) {
			ASSERT(*i == counter);
			ASSERT(i() == counter);
			ASSERT(i! == counter);
			++counter;
		}
		ASSERT(counter == 5);
	}

	TEST "number range for: reverse" {
		counter ::= 5;
		FOR(i ::= 5; --) {
			--counter;
			ASSERT(*i == counter);
			ASSERT(i() == counter);
			ASSERT(i! == counter);
		}
		ASSERT(counter == 0);
	}/)
}
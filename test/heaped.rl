INCLUDE 'std/heaped'

::std::test_heaped TEST "heaped ctor"
{
	x: INT-std::Heaped := 5;
	ASSERT(x! == 5);
	ASSERT(x);

	y: INT-std::Heaped;
	ASSERT(y! == 0);
	ASSERT(y);

	moved: INT-std::Heaped := &&x;
	ASSERT(moved! == 5);
	ASSERT(!x);
	x := 6;
	ASSERT(x! == 6);
	ASSERT(&x! != &moved!);

	cpy: INT-std::Heaped := x;
	ASSERT(cpy! == 6);
	ASSERT(x);
}
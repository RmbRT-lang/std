INCLUDE 'std/dyn'

::std::test_heaped TEST "dyn ctor"
{
	x: INT-std::Dyn := 5;
	ASSERT(x! == 5);
	ASSERT(x);

	y: INT-std::Dyn;
	ASSERT(y! == 0);
	ASSERT(y);

	moved: INT-std::Dyn := &&x;
	ASSERT(moved! == 5);
	ASSERT(!x);
	x := 6;
	ASSERT(x! == 6);
	ASSERT(&x! != &moved!);

	cpy: INT-std::Dyn := x;
	ASSERT(cpy! == 6);
	ASSERT(x);
}
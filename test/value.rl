INCLUDE 'std/value'

::std::value TEST "Value type semantics"
{
	v: INT-Val := 5;

	old ::= v;

	ASSERT(*v == 5);

	ASSERT(old! == v!);
	ASSERT(&old! == &v!);

	v.mut() := 4;
	ASSERT(&old! != &v!);

	x ::= &v!;
	v.mut() := 3;
	ASSERT(x == &v!);
	ASSERT(*x == 3);
}
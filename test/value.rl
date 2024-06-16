INCLUDE 'std/value'

::std::value TEST "Value type semantics"
{
	v: INT-Val := 5;
	vc ::= v.shared().container();
	vp ::= v.ptr();
	ASSERT(hash(v.shared()) == hash(5));
	ASSERT(hash(*v) == hash(5));
	ASSERT(vc->Refs == 1);
	old ::= v;
	oldp ::= old.ptr();
	ASSERT(vc->Refs == 2);

	ASSERT(*v == 5);

	ASSERT(vp == oldp);
	ASSERT(old! == v!);
	ASSERT(&old! == &v!);
	ASSERT(&old! == old.ptr());

	ASSERT(vc->Refs == 2);
	v.mut() := 4;
	ASSERT(v.ptr() != vp);
	ASSERT(vc->Refs == 1);
	ASSERT(&old! != &v!);

	x ::= &v!;
	v.mut() := 3;
	ASSERT(x == &v!);
	ASSERT(*x == 3);
}
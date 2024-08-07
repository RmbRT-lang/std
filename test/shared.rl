INCLUDE "../std/shared"

::std TEST "shared creation"
{
	s: [INT]Shared := 4;
	ASSERT(s != NULL);
	ASSERT(*s == 4);
}

::std TEST "shared copy"
{
	s: INT-Shared := 4;
	share ::= s;
	ASSERT(share! == s!);
	ASSERT(*s == 4);
	s := 5;
	ASSERT(share! != s!);
	ASSERT(*s == 5);
}

::std TEST "shared move"
{
	s: INT-Shared := 32;
	share ::= &&s;
	ASSERT(!s);
	ASSERT(*share == 32);
}

BaseClass VIRTUAL { B: INT; }
BaseClass2 { B2: INT; }
Derived1 -> BaseClass2, BaseClass { D: INT; }
Derived2 -> BaseClass, BaseClass2 { D: INT; }

::std TEST "shared cast"
{
	s: Derived1-Shared;
	sc: BaseClass#-Shared# := :<>(s);
	s2: BaseClass-Shared := :<>(s);
	ASSERT(s.ptr() == s2.ptr());


	s3: Derived2-SharedOpt := :try(s2);
	ASSERT(s3.ptr() == NULL);
}

::std TEST "polymorphism"
{
	{
		s: BaseClass-SharedOpt := :share(:a.Derived1);
		s2 ::= &&s;
		s3 ::= s2;
		ASSERT(!s3.is_unique());
		s3.clone_if_shared();
		ASSERT(s3.is_unique());
		s3.clone_if_shared();
		s2 := s3;
	}

	{
		s: BaseClass-SharedOpt := :share(:a.Derived2);
		s2 ::= &&s;
		s3 ::= s2;
		ASSERT(!s3.is_unique());
		s3.clone_if_shared();
		ASSERT(s3.is_unique());
		s2 := s3;
	}
}

::std TEST "Shared(BARE) regression test" {
	/// Previously, std::Shared :a(BARE) called CompactAlloc(BARE), which called SharedAlloc(BARE), leading to invalid reference tracking.

	x: INT-std::Shared := :a(BARE);
}
::std::test::shared [T:TYPE]clone_if_shared() VOID {
	x: BaseClass-std::Shared := :a.T;
	y ::= x;

	x!.B := 5;
	<<T &>>(x!).B2 := 6;
	<<T &>>(x!).D := 7;

	y.clone_if_shared();

	ASSERT(TYPE(x!) == TYPE(y!));
	ASSERT(TYPE(x!) == TYPE TYPE(T));
	ASSERT(x.ptr() != y.ptr());

	xd ::= <<T *>>(x.ptr());
	yd ::= <<T *>>(y.ptr());
	ASSERT(xd->B == 5);
	ASSERT(yd->B == 5);
	ASSERT(xd->B2 == 6);
	ASSERT(yd->B2 == 6);
	ASSERT(xd->D == 7);
	ASSERT(yd->D == 7);

	ASSERT(SIZEOF(#x) == SIZEOF(#y));
	ASSERT(0 == std::mem::cmp(<U1#*>(&&&x!), <U1#*>(&&&y!), SIZEOF(#x)));
}
::std TEST "Shared::clone()" {
	test::shared::[Derived1]clone_if_shared();
	test::shared::[Derived2]clone_if_shared();
}
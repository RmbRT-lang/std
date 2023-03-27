INCLUDE "../std/shared"

::std TEST "shared creation"
{
	s: [INT]Shared := :a(4);
	ASSERT(s != NULL);
	ASSERT(*s == 4);
}

::std TEST "shared copy"
{
	s: INT-Shared := :a(4);
	share ::= s;
	ASSERT(share! == s!);
	ASSERT(*s == 4);
	s := :a(5);
	ASSERT(share! != s!);
	ASSERT(*s == 5);
}

::std TEST "shared move"
{
	s: INT-Shared := :a(32);
	share ::= &&s;
	ASSERT(!s);
	ASSERT(*share == 32);
}

BaseClass VIRTUAL { }
Derived1 -> BaseClass { }
Derived2 -> BaseClass { }

::std TEST "shared cast"
{
	s: Derived1-Shared := :a();
	s2: BaseClass-Shared := :<>(s);
	ASSERT(s.ptr() == s2.ptr());

	s3: Derived2-Shared := :try(s2);
	ASSERT(s3.ptr() == NULL);
}
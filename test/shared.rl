INCLUDE "../std/shared"

::std TEST "shared creation"
{
	s: [INT]Shared := :new(4);
	ASSERT(s != NULL);
	ASSERT(*s == 4);
}

::std TEST "shared copy"
{
	s: INT-Shared := :new(4);
	share ::= s;
	ASSERT(share! == s!);
	ASSERT(*s == 4);
	s := :new(5);
	ASSERT(share! != s!);
	ASSERT(*s == 5);
}

::std TEST "shared move"
{
	s: INT-Shared := :new(32);
	share ::= &&s;
	ASSERT(!s);
	ASSERT(*share == 32);
}

BaseClass VIRTUAL { }
Derived1 -> BaseClass { }
Derived2 -> BaseClass { }

::std TEST "shared cast"
{
	s: Derived1-Shared := :new();
	s2: BaseClass-Shared := s;
	ASSERT(s! == s2!);

	s3: Derived2-Shared := :try(s2);
	ASSERT(s3! == NULL);
}
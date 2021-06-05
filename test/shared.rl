INCLUDE "../std/shared"

::std TEST "shared creation"
{
	s ::= [INT]Shared(:create, 4);
	ASSERT(s != NULL);
	ASSERT(*s == 4);
}

::std TEST "shared copy"
{
	s ::= [INT]Shared(:create, 4);
	share ::= s;
	ASSERT(&*share == &*s);
	ASSERT(*s == 4);
	s := [INT]Shared(:create, 5);
	ASSERT(&*share != &*s);
	ASSERT(*s == 5);
}
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
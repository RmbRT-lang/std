::lang::switch
{
	TEST "Case match"
	{
		SWITCH(5) {
		CASE 5: {;}
		CASE 6: ASSERT(FALSE);
		}
	}
	TEST "No matching case"
	{
		SWITCH(5) {
		CASE 4: ASSERT(FALSE);
		CASE 6: ASSERT(FALSE);
		}
	}

	TEST "Default case"
	{
		SWITCH(4) {
		DEFAULT: {;}
		CASE 5, 6: ASSERT(FALSE);
		}
	}

	ENUM E
	{
		a,b
	}

	TEST "Switch enum values"
	{
		a: E := E::a;
		SWITCH(a)
		{
		CASE E::a: {;}
		CASE E::b: ASSERT(FALSE);
		DEFAULT: ASSERT(FALSE);
		}
	}
}
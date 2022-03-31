::lang::switch
{
	TEST "Case match"
	{
		SWITCH(5) {
		5: {;}
		6: ASSERT(FALSE);
		}
	}

	TEST "No matching case, strict"
	{
		panicked: BOOL;
		TRY SWITCH(5) {
		4: ASSERT(FALSE);
		6: ASSERT(FALSE);
		}
		CATCH(CHAR#\) panicked := TRUE;
		ASSERT(panicked);
	}

	TEST "No matching case, permissive"
	{
		SWITCH?(5) {
		4: ASSERT(FALSE);
		6: ASSERT(FALSE);
		}
	}

	TEST "Default case"
	{
		SWITCH(4) {
		DEFAULT: {;}
		5, 6: ASSERT(FALSE);
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
		E::a: {;}
		E::b: ASSERT(FALSE);
		DEFAULT: ASSERT(FALSE);
		}
	}
}
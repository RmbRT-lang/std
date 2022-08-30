::lang::switch
{
	TEST "Case match"
	{
		SWITCH(5) {
		5: {;}
		6: DIE;
		}
	}

	TEST "No matching case, strict"
	{
		panicked: BOOL;
		TRY SWITCH(5) {
		4: {;}
		6: {;}
		}
		CATCH(CHAR#\) panicked := TRUE;
		ASSERT(panicked);
	}

	TEST "No matching case, permissive"
	{
		SWITCH?(5) {
		4: DIE;
		6: DIE;
		}
	}

	TEST "Default case"
	{
		SWITCH(4) {
		DEFAULT: {;}
		5, 6: DIE;
		}
	}

	ENUM E
	{
		a,b
	}

	TEST "Switch enum values"
	{
		a: E := :a;
		SWITCH(a)
		{
		:a: {;}
		:b: DIE "b matched instead of a";
		DEFAULT: DIE "invalid value matched";
		}
	}
}
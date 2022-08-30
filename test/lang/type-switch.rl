::rl::lang::typeswitch
{
	Base VIRTUAL {}
	D1 -> Base {}
	D2 -> Base {}

	TEST "Switching type (INT)"
	{
		TYPE SWITCH STATIC(23)
		{
		INT: {;}
		DEFAULT:
			DIE "expected INT as type";
		}
	}

	TEST "Switching type (Base)"
	{
		TYPE SWITCH STATIC(*<Base *>(NULL))
		{
		Base: {;}
		DEFAULT:
			DIE "expected BASE as type";
		}
	}

	TEST "Switch virtual type"
	{
		v: D1;
		TYPE SWITCH(<Base &>(v))
		{
		D1: {;}
		DEFAULT:
			DIE "expected D1 as type";
		}
	}

	TEST "Switching type (strict)"
	{
		v: D1;

		threw ::= FALSE;
		TRY TYPE SWITCH STATIC(v) { INT:{;} }
		CATCH({CHAR#\, CHAR#\}){threw := TRUE; }
		ASSERT(threw);
	}

	TEST "Switching type (lenient)"
	{
		v: D1;
		TYPE SWITCH STATIC?(v) { INT:{;} }
	}
}
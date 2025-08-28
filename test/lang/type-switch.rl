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

	ENUM Switch { a, b, c }
	TEST "Switch enum, anonymous cases" {
		SWITCH(<Switch>(Switch::a))
		{
		:a: {}
		:b: DIE;
		:c: DIE;
		}
	}
	TEST "Switch enum, qualified cases" {
		SWITCH(<Switch>(Switch::a))
		{
		Switch::a: {}
		Switch::b: DIE;
		Switch::c: DIE;
		}
	}

	TEST "Switch enum constant, anonymous cases" {
		SWITCH(Switch::a)
		{
		:a: {}
		:b: DIE;
		:c: DIE;
		}
	}
	TEST "Switch enum constant, qualified cases" {
		SWITCH(Switch::a)
		{
		Switch::a: {}
		Switch::b: DIE;
		Switch::c: DIE;
		}
	}

	UNION U {
		X; // TODO: parse anonymous variables.
		Y: :bb;
		Z: :cc;
	}

	TEST "Switch tagged union fields" {
		u: TAGGED U := :Z;

		SWITCH!(u)
		{
		:X: DIE;
		:Y: DIE;
		:Z: {}
		}
	}
}
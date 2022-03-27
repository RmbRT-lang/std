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
			ASSERT(!"expected INT as type");
		}
	}

	TEST "Switching type (Base)"
	{
		TYPE SWITCH STATIC(*<Base *>(NULL))
		{
		Base: {;}
		DEFAULT:
			ASSERT(!"expected BASE as type");
		}
	}

	TEST "Switch virtual type"
	{
		v: D1;
		TYPE SWITCH(<Base &>(v))
		{
		D1: {;}
		DEFAULT:
			ASSERT(!"expected D1 as type");
		}
	}
}
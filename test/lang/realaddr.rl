::lang::realaddr {

	Base1 VIRTUAL {
		V1: INT;
	}
	Base2 VIRTUAL {
		V2: INT;
	}

	Derived -> Base1, Base2 {
		D: INT;
	}

	TEST "real address"
	{
		d: Derived;
		base1: Base1& := d;
		base2: Base2& := d;

		ASSERT(&&&d == &d);
		ASSERT(&&&base1 == &d);
		ASSERT(&&&base2 == &d);
		ASSERT(<VOID#*>(&base1) != &base2);
	}
}
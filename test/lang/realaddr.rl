INCLUDE 'std/memory'

::lang::realaddr {

	Base1 VIRTUAL { INT; }
	Base2 VIRTUAL { INT; }

	Derived1 VIRTUAL -> Base1 { INT; }

	Derived -> Base2, Derived1 { INT; }

	TEST "real address"
	{
		d: Derived;
		base1: Base1 & (d);
		base2: Base2 & (d);
		derived1: Derived1 & (d);

		ASSERT(&&&d == &d);
		ASSERT(&&&derived1 == &&&d);
		ASSERT(&&&base2 == &&&d);
		ASSERT(<VOID#*>(&base1) > &base2);
		ASSERT(<VOID#*>(&base1) > &d);
		ASSERT(<VOID#*>(&derived1) != &d);
		ASSERT(<VOID#*>(&derived1) > &base2);
		ASSERT(<VOID#*>(&base2) == &d);
		ASSERT(<VOID#*>(&derived1) == &base1);
	}
}
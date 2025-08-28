::lang::enum
{
	ENUM E { a, b, c }

	TEST "symbolic enum"
	{
		x: E := :a;
		ASSERT(x == E::a);
		x := :b;
		ASSERT(x == E::b);
		ASSERT(x != :a);
	}

	TEST "switch symbol constant"
	{
		SWITCH(E::a)
		{
		:b: DIE;
		:a: {;}
		DEFAULT: DIE;
		}
	}
	TEST "switch symbol constant variable"
	{
		SWITCH(x ::= E::a)
		{
		:a: {;}
		DEFAULT:
			DIE;
		}
	}

	ENUM WithDefault {
		one,
	*	two,
		three
	}

	TEST "default enum constant" {
		x: WithDefault;
		ASSERT(x == :two);
	}

	ENUM Truthy {
	?	Ok,
		Error
	}

	TEST "truthy enum constant" {
		ASSERT(TRUE == <Truthy>(Truthy::Ok));
		ASSERT(FALSE == !<Truthy>(Truthy::Ok));
		ASSERT(FALSE == <Truthy>(Truthy::Error));
		ASSERT(TRUE == !<Truthy>(Truthy::Error));

		ok: Truthy := :Ok;
		ASSERT(ok);
		ASSERT(!ok == FALSE);
		err: Truthy := :Error;
		ASSERT(!err);
		ASSERT(err == FALSE);
	}

	Pod{ X: INT; }
	UNION U {
		A: INT;
	!?	B: Pod;
	}

	TEST "Tagged union ValueOf field" {
		u: TAGGED U := :A(5);
		ASSERT(!u);
		ASSERT(u == FALSE);
		
		u := :B(7);
		ASSERT(u);
		ASSERT(!u == FALSE);
		ASSERT(&u->X == &u.(1).B.X);
		ASSERT(&u!.X == &u.(1).B.X);
		ASSERT(&(*u).X == &u.(1).B.X);
	}
}
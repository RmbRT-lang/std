::lang::constructors
{
	Class {
		V: INT;

		{}: V(1);
		{#&}: V(2);
		{&&}: V(3);

		{v: INT}: V(v);

		:custom1{}: V(4);
		:custom2{v: INT}: V(v+1);
		:<{v: INT}: V(v+2);

		# <INT> := V;
	}

	TEST "special constructors"
	{
		default: Class;
		ASSERT(default.V == 1);
		copy: Class := default;
		ASSERT(copy.V == 2);
		move: Class := &&copy;
		ASSERT(move.V == 3);
	}

	TEST "custom constructor"
	{
		custom: Class := 5;
		ASSERT(custom.V == 5);
	}

	TEST "variant constructor"
	{
		custom: Class := :custom1;
		ASSERT(custom.V == 4);
		custom2: Class := :custom2(6);
		ASSERT(custom2.V == 7);
		special: Class := :<(6);
		ASSERT(special.V == 8);
	}

	PODType {
		X: INT;
		Y: INT;
	}

	TEST "structural constructor"
	{
		x: PODType := (5, 6);
		ASSERT(x.X == 5);
		ASSERT(x.Y == 6);
	}

	Point2 {
		X: INT;
		Y: INT;

		:origin{} (0,0);
		PRIVATE {...};

		:f{x: INT} (x, 5*x);
	}

	TEST "manual structural constructor"
	{
		p: Point2 := :origin;
		ASSERT(p.X == 0);
		ASSERT(p.Y == 0);
		p2: Point2 := :f(5);
		ASSERT(p2.X == 5);
		ASSERT(p2.Y == 25);
	}
}
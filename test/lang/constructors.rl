INCLUDE 'std/heap'

::lang::constructors
{
	Class {
		V: INT;

		{}: V(1);
		{#&}: V(2);
		{&&}: V(3);
		{BARE}: V(4);

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
		bare: Class (BARE);
		ASSERT(bare.V == 4);
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
		{BARE}: X(5), Y(6);

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

	BareContainer {
		P: Point2;
		C: Class;
	}

	TEST "bare constructor"
	{
		x: BareContainer (BARE);
		ASSERT(x.C.V == 4);
		ASSERT(x.P.X == 5);
		ASSERT(x.P.Y == 6);
	}

	Base VIRTUAL {}
	D1 VIRTUAL -> Base { INT; }
	D2 -> D1 { x: INT; }

	TEST "Virtual Ctor abstract base object cloning" {
		d2: D2; d2.x := 25;
		b: Base& := d2;
		
		ASSERT(SIZEOF(#d2) == SIZEOF(#b));
		
		clone ::= <Base *>(std::heap::alloc_raw(SIZEOF(#b)));
		COPY_RTTI(b, clone);
		clone->VIRTUAL{b};
		
		ASSERT(TYPE(clone) == TYPE TYPE (D1));
		ASSERT(TYPE(<<D1*>>(clone)) == TYPE TYPE(D2));
		ASSERT(<<D2#*>>(clone)->x == 25);
		
		std::heap::delete(clone);
	}

	NoDefaultCtor {
		Member: UM;

		{x: INT *} {
			std::io::write(&std::io::out, "ctor(x: ", :addr(x), ")\n");
		}
	}

	Y -> NoDefaultCtor {}

	TEST "No Default CTOR" {
		x: Y;
	}
}
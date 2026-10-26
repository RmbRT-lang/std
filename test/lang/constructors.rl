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
		
		(/clone ::= <Base *>(std::heap::alloc.alloc_raw_object(SIZEOF(#b), 8));
		COPY_RTTI(b, clone);
		clone->VIRTUAL{b};
		
		ASSERT(TYPE(clone) == TYPE TYPE (D1));
		ASSERT(TYPE(<<D1*>>(clone)) == TYPE TYPE(D2));
		ASSERT(<<D2#*>>(clone)->x == 25);
		
		std::heap::alloc.delete(clone);/)
	}

	NoDefaultCtor {
		Member: UM;

		{x: INT *} {
			//std::io::write(&std::io::out, "ctor(x: ", :addr(x), ")\n");
		}
	}

	Y -> NoDefaultCtor {}

	TEST "No Default CTOR" {
		x: Y;
	}

	UNION CtorUnion {
		Field1: INT;
		Field2: BOOL;
		Field3: Point2;
	}
	TEST "UNION field ctors" {
		u: CtorUnion;
		u.{:Field1(5)};
		ASSERT(u.Field1 == 5);
		u.{:Field2(FALSE)};
		ASSERT(u.Field2 == FALSE);
		u.{:Field3(:f(7))};
		ASSERT(u.Field3.X == 7);
		ASSERT(u.Field3.Y == 5*7);
	}

	TEST "UNION tag enums" {
		e: ENUM CtorUnion (BARE);
		e := :Field1;
		e := :Field2;
		e := :Field3;
	}

	TEST "TAGGED unions" {
		t: TAGGED CtorUnion (BARE);

		t := :Field1(5);
		ASSERT(t.(0) == :Field1);
		ASSERT(t.(1).Field1 == 5);
		t := :Field2(FALSE);
		ASSERT(t.(0) == :Field2);
		ASSERT(t.(1).Field2 == FALSE);
		t := :Field3(:f,7);
		t := :Field3(:f(7));
		ASSERT(t.(0) == :Field3);
		ASSERT(t.(1).Field3.X == 7);
		ASSERT(t.(1).Field3.Y == 5*7);
	}

	DefaultCtorable { X: INT; {}: X := 12345; }
	DefaultCtorable2 { X: INT; {}: X := 987654; }
	UNION CtorUnionDefault {
		Field1: DefaultCtorable2;
		Field2: BOOL;
		Field3: BOOL;
	*	Field4: DefaultCtorable;
		Field5: BOOL;
		Field6: DefaultCtorable2;
	}
	TEST "DEFAULT TAGGED union" {
		t: TAGGED CtorUnionDefault;
		ASSERT(t.(0) == :Field4);
		ASSERT(t.(1).Field4.X == 12345);
	}

	DestroyingClass { X: INT; Into: INT *; DESTRUCTOR { *Into := X; } }
	UNION DestroyingUnion { Pod: INT; Dtor1: DestroyingClass; Dtor2: DestroyingClass; }
	TEST "TAGGED union destructor" {
		// Currently, tagged unions have NOP destructors.
		(/test: INT := 0;
		{ t: TAGGED DestroyingUnion := :Dtor1(5, &test); }
		ASSERT(test == 5);
		{ t: TAGGED DestroyingUnion := :Dtor1(4, &test); t.(0) := :Pod; }
		ASSERT(test == 5);/)
	}
}
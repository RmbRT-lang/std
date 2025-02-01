::lang::ops
{
	Point { x: INT; {}: x(1); }
	Type
	{
		p: Point;

		++THIS INT := 1;
		*THIS Point& -- { = p; }
		THIS*(vint: INT) INT -- := 2;
		THIS(lel: INT, y: INT) VOID {}
		THIS[i: INT] INT := i;
		<-THIS VOID {}
		//THIS? (a: INT): (b: INT) INT := i;
		THIS<<(i: INT) INT := -i;

		THIS<-(i: INT) ?& := THIS;
	}

	TEST "operator overloading"
	{
		t: Type;
		ASSERT(++t == 1);
		ASSERT(t * 5 == 2);
		ASSERT(&*t == &t.p);
		ASSERT(t[23] == 23);
		ASSERT(t << 123 == -123);
		ASSERT(&((t <- 1) <- 2) == &t);
	}

	TEST "operator->"
	{
		t: Type;
		t.p.x := 5;
		ASSERT((*t).x == 5);
		ASSERT(t->x == 5);
	}

	U4Wrap {
		X: U4;
		{x:U4}--: X := x;

		# BSWAP THIS U4 := BSWAP X;
		# POPCNT THIS U1 := POPCNT X;
	}

	TEST "BSWAP" {
		x: U4Wrap := 0x01020304;
		ASSERT(BSWAP x == 0x04030201);
	}
	TEST "POPCNT" {
		x: U4Wrap := 0x1234567;
		ASSERT(POPCNT x == 12);
	}
}
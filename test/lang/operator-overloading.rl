::lang::ops
{
	Point { x: INT; {}: x(1); }
	Type
	{
		p: Point;

		++THIS INT := 1;
		*THIS Point& INLINE { = p; }
		THIS*(vint: INT) INT INLINE := 2;
		THIS(lel: INT, y: INT) VOID {}
		THIS[i: INT] INT := i;
		<-THIS VOID {}
		//THIS? (a: INT): (b: INT) INT := i;
		THIS<<(i: INT) INT := -i;

		THIS<-(i: INT) & ::= THIS;
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
}
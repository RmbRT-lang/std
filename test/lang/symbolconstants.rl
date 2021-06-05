::lang
{
	n: :null;
	TYPE x := :cstring;
	fn(:null) INT := 0;
	fn(x: INT) INT := x;

	TEST "symbol constants"
	{
		ASSERT(fn(:null) == 0);
		ASSERT(fn(n) == 0);
		ASSERT(fn(0) == 0);
		ASSERT(fn(3) == 3);
	}

	f(:default) INT := 34;
	f(n: INT) INT := n * n;

	y: INT := f(:default);
}
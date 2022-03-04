::lang
{
	n: :null;
	TYPE x := :cstring;
	fn(:null) INT := 0;

	TEST "symbol constants"
	{
		ASSERT(fn(:null) == 0);
		ASSERT(fn(n) == 0);
	}
}
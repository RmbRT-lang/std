INCLUDE "../std/string"

::std
{
	TEST "str::view"
	{
		str ::= "123456";
		buf ::= str::c(str);
		ASSERT(&*buf[] == &str[0]);
		ASSERT(##buf == 6);
	}

	TEST "str::len"
	{
		ASSERT(str::len("test") == 4);
		ASSERT(str::len("12345") == 5);
		ASSERT(str::len("") == 0);
	}

	TEST "str::cmp"
	{
		ASSERT(str::order("a", "b") < 0);
		ASSERT(str::order("a", "a") == 0);
		ASSERT(str::order("aa", "a") > 0);
		ASSERT(str::order("", "a") < 0);
	}

	TEST "str::starts_with"
	{
		ASSERT(str::starts_with("hello", "hell"));
		ASSERT(!str::starts_with("hell", "hello"));
		ASSERT(str::starts_with("test", "test"));
		ASSERT(str::starts_with("test",  ""));
		ASSERT(str::starts_with("",  ""));
	}
}
INCLUDE "../std/string"

::std
{
	TEST "str::view"
	{
		str ::= "123456";
		buf ::= str::view(str);
		ASSERT(buf.Data == str);
		ASSERT(buf.Size == 6);
	}

	TEST "str::len"
	{
		ASSERT(str::len("test") == 4);
		ASSERT(str::len("12345") == 5);
		ASSERT(str::len("") == 0);
	}

	TEST "str::cmp"
	{
		ASSERT((str::view("a") <> "b") < 0);
		ASSERT((str::view("a") <> "a") == 0);
		ASSERT((str::view("aa") <> "a") > 0);
		ASSERT((str::view("") <> "a") < 0);
	}

	TEST "str::starts_with"
	{
		ASSERT(str::view("hello") >= "hell");
		ASSERT(!(str::view("hell") >= "hello"));
		ASSERT(str::view("test") >= "test");
		ASSERT(str::view("test") >= "");
		ASSERT(str::view("") >= "");
	}
}
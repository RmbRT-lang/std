INCLUDE "../std/string"

::std
{
	TEST "str::view"
	{
		str ::= "1234546";
		buf ::= str::view(str);
		IF(buf.Data != str && buf.Size != 6) THROW;
	}

	TEST "str::len"
	{
		IF(str::len("test") != 4
		|| str::len("12345") != 5
		|| str::len("") != 0) THROW;
	}

	TEST "str::cmp"
	{
		IF(str::view("a").cmp("b") >= 0
		|| str::view("a").cmp("a") != 0
		|| str::view("aa").cmp("a") <= 0
		|| str::view("").cmp("a") >= 0) THROW;
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
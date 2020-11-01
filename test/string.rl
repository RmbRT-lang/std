INCLUDE "../std/string"

::std
{
	TEST "str::buf"
	{
		str ::= "1234546";
		buf ::= str::buf(str);
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
		IF(str::cmp("a", "b") >= 0
		|| str::cmp("a", "a") != 0
		|| str::cmp("aa", "a") <= 0
		|| str::cmp("", "a") >= 0) THROW;
	}

	TEST "str::starts_with"
	{
		IF(!str::starts_with("hello", "hell")
		|| str::starts_with("hell", "hello")
		|| !str::starts_with("test", "test")
		|| !str::starts_with("test", "")
		|| !str::starts_with("", "")) THROW;
	}
}
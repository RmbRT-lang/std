INCLUDE "../std/unicode"
INCLUDE "../std/memory"

::std::code::utf8
{
	TEST "size"
	{
		ASSERT(size(*"´") == 2);
		ASSERT(size(*"a") == 1);
		ASSERT(size(*"…") == 3);
		ASSERT(size(*"€") == 3);
	}

	TEST "is_follow"
	{
		ASSERT(is_follow("´"[1]));
		ASSERT(!is_follow("´"[0]));
	}

	TEST "point"
	{
		ASSERT(point("€") == 0x20AC);
		ASSERT(point("退") == 0x9000);
		ASSERT(point("a") == 'a');
		ASSERT(point("") == 0);
	}

	TEST "encode"
	{
		ASSERT(test::encode('a', "a"));
		ASSERT(test::encode(0x9000, "退"));
		ASSERT(test::encode(0x00B4, "´"));
		ASSERT(test::encode(0x20AC, "€"));
	}
	::test encode(c: SYM, str: CHAR#\) BOOL
	{
		buf: CHAR[4];
		len ::= utf8::encode(c, buf);
		RETURN size(buf[0]) == len
			&& memcmp(buf, str, len) == 0;
	}
}
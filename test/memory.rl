INCLUDE "../std/memory"

::std
{
	TEST "memcmp"
	{
		ASSERT(memcmp("aaa", "aab", 3) < 0);
		buf: char[3](char(0xe2), char(0x82), char(0xac));
		ASSERT(memcmp("€", buf, 3) == 0);
	}
}
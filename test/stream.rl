INCLUDE "../std/io/stream"
INCLUDE "../std/vector"
INCLUDE "../std/string"

::std::io
{
	StreamToVector
	{
		Data: std::Utf8 - std::Vector;
		write_some(data: VOID #\, size: UM) UM {
			Data += <Utf8>((<CHAR#\>(data), size));
			RETURN size;
		}

		# THIS==(expect: CHAR#\ - std::Vector #&) BOOL
		{
			IF(##expect != ##Data)
				RETURN FALSE;
			FOR(i ::= 0; i < ##Data; i++)
				IF(0 != str::cmp(str::buf(expect[:ok(i)]), Data[:ok(i)]!))
					RETURN FALSE;
			RETURN TRUE;
		}
	}

	TEST "OStream"
	{
		buf: StreamToVector;
		o ::= <<<std::io::OStream>>>(&buf);

		o.write_all("hello", "world");
		ASSERT(buf == :emplace("hello", "world"));
	}
}
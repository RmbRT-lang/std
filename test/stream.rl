INCLUDE "../std/io/stream"
INCLUDE "../std/vector"
INCLUDE "../std/string"

::std::io
{
	StreamToVector
	{
		Data: std::Utf8 - std::Vector;
		write_some_impl(data: VOID #\, size: UM) UM {
			Data += <Utf8>(:buf(<CHAR#\>(data), size));
			= size;
		}

		# THIS==(expect: str::C8CView - std::Vector #&) BOOL
		{
			IF(##expect != ##Data)
				= FALSE;
			FOR(i ::= 0; i < ##Data; i++)
				IF(expect[i] != Data[i]!)
					= FALSE;
			= TRUE;
		}
	}

	TEST "OStream"
	{
		buf: StreamToVector;
		o ::= <<<std::io::OStream>>>(&buf);

		o.write("hello", "world");
		ASSERT(buf == :vec("hello", "world"));
	}
}
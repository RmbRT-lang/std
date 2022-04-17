INCLUDE "../std/io/stream"
INCLUDE "../std/vector"
INCLUDE "../std/string"
INCLUDE 'std/io/file'
INCLUDE 'std/io/streamutil'

::std::io
{
	StreamToVector
	{
		Data: std::Str - std::Vector;
		write_some(data: VOID #\, size: UM) UM {
			Data += <Str>(:buf(<CHAR#\>(data), size));
			= size;
		}

		# THIS==(expect: str::CV - std::Vector #&) BOOL
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

		io::write(o, "hello", "world", :dec(25), :dec(-40), :hex(-0x23));
		ASSERT(buf == :vec("hello", "world", "25", "-40", "-0x23"));
	}
}
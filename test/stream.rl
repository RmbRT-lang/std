INCLUDE "../std/io/stream"
INCLUDE "../std/vector"
INCLUDE "../std/string"
INCLUDE 'std/io/file'
INCLUDE 'std/io/streamutil'

::std::io
{
	StreamToVec
	{
		Data: std::Str - std::Vec;
		write_some(data: VOID #\, size: UM) UM {
			Data += <Str>(:buf(<CHAR#\>(data), size));
			= size;
		}

		# THIS==(expect: str::CV - std::Vec #&) BOOL
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
		buf: StreamToVec;

		x: VOID #* := <VOID #*>(<UM>(0x6432f46));

		io::write(&buf, "hello", "world", :dec(25), :dec(-40), :hex(-0x23), :addr(x), :hexm(<UM>(x)));

		ASSERT(buf == :vec("hello", "world", "25", "-40", "-0x23", "0x6432f46", "0x0000000006432f46"));
	}
}
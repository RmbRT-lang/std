INCLUDE "../std/io/stream"
INCLUDE "../std/vector"
INCLUDE "../std/string"
INCLUDE "../std/streambuffer"
INCLUDE 'std/io/streamutil'

::std::io
{
	StreamToVec
	{
		Data: std::Str - std::Vec;
		write_some(data: VOID #\, size: UM) UM {
			Data += <Str>(<CHAR#\>(data)[FOR size]);
			= size;
		}

		# THIS==(expect: CHAR#[#]-std::Vec#&) BOOL
		{
			IF(##expect != ##Data)
				= FALSE;
			FOR(Data!)
				IF(str::order(expect[IOTA], IT!) != 0)
					= FALSE;
			= TRUE;
		}

		# stream(o: std::io::OStream &) VOID
		{
			FOR(Data!) std::io::write(o, IT!);
		}
	}

	TEST "OStream"
	{
		buf: StreamToVec;

		x: VOID #* := <VOID #*>(<UM>(0x6432f46));

		io::write(&buf, "hello", "world", :dec(25), :dec(-40), :hex(-0x23), :addr(x), :hexm(<UM>(x)));

		ASSERT(buf == :vec("hello", "world", "25", "-40", "-0x23", "0x6432f46", "0x0000000006432f46"));

		TRY {
			buf2: StreamToVec;
			std::io::write(&buf2, :stream(buf));
			ASSERT((buf2.Data <> buf.Data) == 0);
		} CATCH(t: {CHAR #*, CHAR#*}) {
			msg: StreamBuffer;
			std::io::write(&msg, std::str::c(t.(0)[]), " (", std::str::c(t.(1)[]), ")", :ch(0));
			THROW &msg![0];
		}

		text: StreamBuffer;
		io::write(&text, "Hello,", :ch(' '), "world!\n", :dec(255));
		text2: StreamBuffer;
		io::write(&text2, :stream(&text), "\n", :stream(&text));
		ASSERT(std::str::order(text!, "Hello, world!\n255") == 0);
		ASSERT(std::str::order(text2!, "Hello, world!\n255\nHello, world!\n255") == 0);
	}
}
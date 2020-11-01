INCLUDE "*"
INCLUDE "../std/io/file"
INCLUDE "../std/io/format"

main() int
{
	succ: int;
	fail: int;
	__rl::test::status(succ, fail);

	out ::= std::io::OStream::FROM(fail ? &std::io::err : &std::io::out);

	std::io::format::dec(out, succ);
	out.write("/");
	std::io::format::dec(out, succ+fail);
	out.write(" TESTS PASSED\n");

	RETURN fail ? 1 : 0;
}
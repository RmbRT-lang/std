INCLUDE 'std/hash'
INCLUDE 'std/io/stream'
INCLUDE 'std/io/file'

::std::hash_test
{
	TestType2 {
		a: INT;
		b: INT;
		{a:INT, b:INT}:a(a),b(b);
	}

	TestType {
		v: TestType2;
		c: INT;
		{v: TestType2, c: INT}: v(v), c(c);
	}

	EmptyHashable -> CustomHashable
	{
		X: INT;

		# FINAL hash(Hasher &) VOID {}
	}

	TEST "Hashing"
	{
		ASSERT(<Hasher>()() == :seed);
		ASSERT(hash(<TestType>((3235, 211), 32)) != :seed);
		ASSERT(hash(0) != hash(1));
		ASSERT(hash(<EmptyHashable>()) == :seed);
	}
}
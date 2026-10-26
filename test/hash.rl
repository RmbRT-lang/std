INCLUDE 'std/hash'
INCLUDE 'std/io/stream'

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

	EmptyHashable
	{
		X: INT;

		# hash(Hasher &) VOID {}
	}

	TEST "Hashing"
	{
		seed ::= hash();
		ASSERT(<Hasher>().digest() == hash());
		ASSERT(hash(<EmptyHashable>()) == seed);
		ASSERT(hash(hash()) != seed);
		ASSERT(hash(<TestType>((3235, 211), 32)) != seed);
		ASSERT(hash(0) != hash(1));

		(/val: INT -Vec- std::Val := :vec();
		s: INT - Vec-std::Shared := val.shared();
		ASSERT(hash(s) == hash(<INT-Buffer>()));/)

		(/ {
			last: Hash;
			FOR(i ::= 0; i < 100; i++)
			{
				h ::= hash(i);
				last.Words[0] ^= h.Words[0];
				std::io::write(&std::io::out,
					:hexm(h.Words[0]), " (", :hexm(last.Words[0]), ")\n");
				last := h;
			}
		}
		{
			last: Hash;
			FOR(i ::= 0; i < 100; i++)
			{
				h ::= hash(hash(i));
				last.Words[0] ^= h.Words[0];
				std::io::write(&std::io::out,
					:hexm(h.Words[0]), " (", :hexm(last.Words[0]), ")\n");
				last := h;
			}
		} /)
	}
}
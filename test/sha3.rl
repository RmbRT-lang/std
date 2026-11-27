INCLUDE 'std/crypto/sha3'


::std::crypto::sha3
{
	TEST "SHA3 empty" {
		empty ::= sha3_256(NULL);

		ASSERT(empty[0] == 0Ra7ffc6f8bf1ed766);
		ASSERT(empty[1] == 0R51c14756a061d662);
		ASSERT(empty[2] == 0Rf580ff4de43b49fa);
		ASSERT(empty[3] == 0R82d80a4b80f8434a);
	}

	TEST "SHA3(abc)" {
		x: U1[3](U1 'a', U1 'b', U1 'c');
		abc ::= sha3_256(x);

		ASSERT(abc[0] == 0R3a985da74fe225b2);
		ASSERT(abc[1] == 0R045c172d6bd390bd);
		ASSERT(abc[2] == 0R855f086e3e9d525b);
		ASSERT(abc[3] == 0R46bfe24511431532);
	}

	TEST "SHA3(a^MEGA)" {
		x: U1[100](U1 'a');
		s: sha3::State;
		FOR(10000) s.update(x);
		a_mega ::= s.sha_digest();
		ASSERT(a_mega[0] == 0R5c8875ae474a3634);
		ASSERT(a_mega[1] == 0Rba4fd55ec85bffd6);
		ASSERT(a_mega[2] == 0R61f32aca75c6d699);
		ASSERT(a_mega[3] == 0Rd0cdcb6c115891c1);
	}
	TEST "Shake(hello)" {
		x: U1[5]; FOR("hello") x[IOTA] := IT;
		s: sha3::State;
		s.update(x);
		s.shake_start();
		hello: U8;
		s.shake_output(<U1 *>(&hello)[FOR 8]);
		ASSERT(hello == 0r1234075ae4a1e773);
	}

	TEST "Shake - extended" {
		x: U1[5]; FOR("hello") x[IOTA] := IT;
		s: sha3::State;
		s.update(x);
		s.shake_start();
		hello: U8;
		FOR(i ::= 0; i < 512; i += 8)
			s.shake_output(<U1 *>(&hello)[FOR 8]);
		ASSERT(hello == 0r249eb087babe1f35);
	}
}
INCLUDE 'std/crypto/dlog'

(/ Test output: (dlog.go on https://go.dev/play)

s: 261041469489027827293313457758831466013 (128 bit)
t: 1250567787648617291554422041854498843 (120 bit)
L: 53
r: 132560185490753432904768736436576877359 (127 bit)
rs: 34603705616244381538395534318332177345160023241089587326330561504707677699667
p0: 39273281083161279603098993030707228180167856059892730599251917711790167833571
s_mod: 19636640541580639801549496515353614090083928029946365299625958855895083916786
r_mod: 14967065074663741736846037802978563255076095211143222026704602648812593782882
K: 80
p: 5575866179682262325746384483963855603405771574634226702812141758465018599780291 (262 bit)

/)

// This is a copy of generate_strong_prime, but with the test case above coded into it.
(/
::std::crypto::dlog TEST "strong prime, test vector" {
	primebits1155: ? #& := *<[# ##primes_1155]BigInt# *>(&primes_1155);

	sanity: [#9]StrongDerivation;
	sanity.S.Digits := <U4[4]>(U4 0xe691561d, U4 0xd46c4978, U4 0xbdcc85ba, U4 0xc462c21e);
	sanity.T.Digits := <U4[4]>(U4 0x32ae581b, U4 0x4fbfa16a, U4 0x97924494, U4 0x00f0d9c0);
	sanity.P.Digits := <U4[9]>(
		U4 0x9bc72fc3, U4 0xc6723e1e, U4 0x613d4ced, U4 0x8dd5b357,
		U4 0x51cec6ae, U4 0x629d9ae5, U4 0xdfccf5fb, U4 0x27746b5a,
		U4 0x00000030);
	sanity.Derivation.L := 53;
	sanity.Derivation.K := 80;

	r ::= sanity.T; r += 1;

	L: U4 := 1;

	{ // 3.
		two_t ::= sanity.T; two_t += two_t;

		t_mod1155: U4; { // t % 1155
			mod ::= sanity.T; mod.mixed_mod_assign_slow_unprotected(1155);
			t_mod1155 := mod.Digits[0];
		}

		r_mod1155 ::= (t_mod1155 + 1) % 1155; // r % 1155
		two_t_mod1155 ::= (2*t_mod1155) % 1155; // 2t % 1155

		FOR[find_r](; ; L++)
		{
			ASSERT(L <= sanity.Derivation.L);
			r_mod1155 -= (r_mod1155 >= 1155) ?? 1155 : 0;

			r += two_t; r_mod1155 += two_t_mod1155;
			{
				mod ::= r;
				mod.mixed_mod_assign_slow_unprotected(1155);
				ASSERT(r_mod1155 == mod.Digits[0]);
			}

			IF(primebits1155.bit(r_mod1155))
				IF(rabin_miller_prime_test(*r.lower(), NULL, 2, 128))
					BREAK [find_r];

		}

		ASSERT(L == sanity.Derivation.L);
	}

	// 4.
	rs: [#Bits]BitInt (NOINIT); r.long_mul_into(s, &rs);

	// 4.1.
	p0: [#Bits]BitInt (0); {
		s_mod: [#Bits]BitInt (NOINIT);
		r_mod: [#Bits]BitInt (NOINIT);

		accel: [#Bits]BitInt::ModuloAccel := :ladder(rs);

		s_long: [#9]BigInt; FOR(s.Digits) s_long.Digits[IOTA] := IT;
		r_long: [#9]BigInt; FOR(r.Digits) r_long.Digits[IOTA] := IT;

		ASSERT(r.Digits[0] & 1);
		ASSERT(s.Digits[0] & 1);
		r_long.Digits[0] ^= 1; // r-1
		s_long.pow_mod_fast_into(r_long, rs, accel, &s_mod); // s_mod = s^(r-1) % rs
		r_long.Digits[0] ^= 1; // restore r

		ASSERT(r.Digits[0] & 1);
		ASSERT(s.Digits[0] & 1);
		s_long.Digits[0] ^= 1; // s-1
		r_long.pow_mod_fast_into(s_long, rs, accel, &r_mod); // r_mod = r^(s-1) % rs
		s_long.Digits[0] ^= 1; // restore s

		// p0 ::= (s_mod - r_mod) % rs
		p0 ::= rs;
		p0 += s_mod;
		p0 -= r_mod;
		IF(p0 >= rs) p0 -= rs;
		ASSERT(p0 < rs);
	}

	// 4.2.
	IF(p0.bit(0) == 0) ASSERT(!p0.add(rs));
	ASSERT(p0.bit(0) == 1);
	//p: ?& := p0;

	p: [#Bits]BitInt;

	// 4.3.
	{
		p_buffer_bits := p_bits - (rs.last1pos()+1);
		os::term::PrintLine_v("p_buffer_bits: ", std::io::format::dec(p_buffer_bits));
		// Make sure we do not overflow here.
		ASSERT(!p0.add_short_mul(rs, 1<<p_buffer_bits));

		p := p0;

		// p = p0 + 2K * rs = p0 + K*(2rs)
		two_rs ::= rs; two_rs += rs;

		p0_mod1155: U4; { // p0 % 1155
			mod ::= p0; mod.mixed_mod_assign_slow_unprotected(1155);
			p0_mod1155 := mod.Digits[0];
		}
		two_rs_mod1155: U4; { // 2rs % 1155
			mod ::= two_rs; mod.mixed_mod_assign_slow_unprotected(1155);
			two_rs_mod1155 := mod.Digits[0];
		}

		p_mod1155 ::= p0_mod1155 % 1155; // p % 1155

		FOR[find_p](; ; K++)
		{
			ASSERT(p.bit(0));
			IF!(K < max_p_attempts)
			{
				os::term::PrintLine_v("max_p_attempts: ", std::io::format::dec(max_p_attempts), " exceeded without finding a prime!"
				"\nBits: ", std::io::format::dec(p_bits));
				DIE;
			}
			p_mod1155 -= (p_mod1155 >= 1155) ?? 1155 : 0;

			{
				mod ::= p;
				mod.mixed_mod_assign_slow_unprotected(1155);
				ASSERT(p_mod1155 == mod.Digits[0]);
			}

			IF(primebits1155.bit(p_mod1155))
				IF(rabin_miller_prime_test(p, NULL, 2, 128))
					BREAK [find_p];

			p += two_rs; p_mod1155 += two_rs_mod1155;
		}
	}

	ASSERT(p.last1pos()+1 >= p_bits);

	ret: [# ##p.Digits]StrongPrimeGen (NOINIT);
	ret.P := p0;
	ret.S := *s.lower(); ret.Derivation.SOff := sd;
	ret.T := *t.lower(); ret.Derivation.TOff := td;
	ret.Derivation.L := L + max_r_attempts;
	ret.Derivation.K := K + max_p_attempts;


}
/)

::std::crypto::dlog TEST "generate strong prime" {
	rng: sha3::State;
	bytes: U1[?](RANDOM U1, RANDOM U1);
	rng.update(bytes);
	rng.shake_start();

	gen ::= dlog::[#3*128]generate_strong_prime(rng);
	ASSERT(gen.verify());
}

::std::crypto::dlog TEST "Diffie-Hellman" {
	rng: sha3::State;
	rng.shake_start();

	gen ::= dlog::[#256]generate_strong_prime(rng);

	p ::= gen.P;

	a: [#256]BitInt;
	b: [#256]BitInt;

	rng.shake_output(a.bytes()); a.truncate_to_bits(248);
	rng.shake_output(b.bytes()); b.truncate_to_bits(248);

	g: [#256]BitInt := 2;

	p_accel # ::= p.accel_mod();

	g_a: [#256]BitInt; g.pow_mod_fast_into(a, p, p_accel, &g_a);
	g_b: [#256]BitInt; g.pow_mod_fast_into(b, p, p_accel, &g_b);

	g_a_b: [#256]BitInt; g_a.pow_mod_fast_into(b, p, p_accel, &g_a_b);
	g_b_a: [#256]BitInt; g_b.pow_mod_fast_into(a, p, p_accel, &g_b_a);

	ASSERT(g_a_b == g_b_a);
}
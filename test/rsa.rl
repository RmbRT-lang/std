INCLUDE 'std/crypto/rsa'

INCLUDE 'os/terminal'
INCLUDE 'std/io/format'

::std::crypto::rsa {
	(/TEST "RSA genprime vs. RSA32" {
		seed: U1[?](U1 1, U1 2, U1 3, U1 CPU_COUNTER, RANDOM U1);
		p_rsa: U4;
		{
			rng: sha3::State ();
			rng.update(seed);
			rng.shake_start();

			p_rsa := [#32]generate_prime(rng, 31).(0).Digits[0];
		}
		p_rsa_32: U4;
		{
			rng: sha3::State ();
			rng.update(seed);
			rng.shake_start();

			p_rsa_32 := rsa32::generate_prime(rng, 31);
		}

		ASSERT(p_rsa == p_rsa_32);


		ASSERT(rsa32::rabin_miller_prime_test(65537, 2, 1));
		ASSERT(rsa32::rabin_miller_prime_test(1381650791, 2, 1000000));

		os::term::PrintLine_v("Prime generated: ", std::io::format::hex_x(p_rsa, 1, FALSE));
	}/)

	TEST "shl_1_digit_mod" {
		s: sha3::State;
		seed: U1[?](U1 1, U1 2, U1 3, U1 4, U1 CPU_COUNTER, RANDOM U1, RANDOM U1);
		s.update(seed);

		s.shake_start();

		last: [#128]BitInt (NOINIT);
		s.shake_output(last.bytes());
		FOR(2048)
		{
			n: [#128]BitInt (NOINIT);
			s.shake_output(n.bytes());
			n.Digits[##n.Digits-1] |= 1<<31;
			n.Digits[0] |= 1;

			accel: [#128]BitInt::ModuloAccel := :ladder(n);

			r: [#128]BitInt ();
			r.carry_mod(1, n);

			sanity_r: [#128*2]BitInt;

			IF#(1)
			{

				ref: [#128]BitInt (0);
				ref.carry_mod(1, n);

				sanity_r.Digits[##n.Digits] := 1;
				sanity_r.mixed_mod_assign_slow_unprotected(n);
				ASSERT(ref == *sanity_r.lower());

				IF!(*sanity_r.lower() == r)
				{
					os::term::Print_v("00000001|");
					FOR(n.Digits; --) os::term::Print_v(std::io::format::hex_x(U4 0, 8, FALSE));
					os::term::Print_v(" % ");
					FOR(n.Digits; --) os::term::Print_v(std::io::format::hex_x(IT, 8, FALSE));
					os::term::Print_v(" = ");
					FOR(sanity_r.lower()->Digits; --) os::term::Print_v(std::io::format::hex_x(IT, 8, FALSE));
					os::term::Print_v(" != ");
					FOR(r.Digits; --) os::term::Print_v(std::io::format::hex_x(IT, 8, FALSE));
					os::term::PrintLine_v();
					DIE;
				}
			}


			IF#(1)
			{
				c ::= r.shl_1_digit_into(&r);
				r.carry_mod(c, n);

				sanity_r := 0;
				sanity_r.Digits[##n.Digits+1] := 1;
				sanity_r.mixed_mod_assign_slow_unprotected(n);
				ASSERT(*sanity_r.lower() == r);
				ASSERT(accel.CarryRem[1] == r);
			}

			last := n;
		}
	}

	TEST "RSA 768" {
		digits: U4[24](
			U4 0xaa493809, U4 0x186cf754, U4 0x3a486159, U4 0xe08d3fdd,
			U4 0xa3212ce8, U4 0x7df1deb9, U4 0x003ef088, U4 0x8bbf96d4,
			U4 0x0731e882, U4 0x54f3132d, U4 0x9d79be84, U4 0x345021c7,
			U4 0x29eb97f3, U4 0x61ecc575, U4 0xe766a3b6, U4 0x897b9de1,
			U4 0x37ff6355, U4 0x3c2420cd, U4 0x435375d4, U4 0x4fc854e0,
			U4 0x10201693, U4 0x715922d3, U4 0x8d02e005, U4 0xa0b56309);

		c: [#1024]BitInt ();
		FOR(digits) c.Digits[IOTA] := IT;
		FOR(c.Digits; --) os::term::Print_v(std::io::format::hex_x(IT, 8, FALSE));
		os::term::PrintLine_v();

		rng: sha3::State;
		rng.update(c.bytes());
		rng.shake_start();

		//ASSERT(rabin_miller_prime_test(c, NULL, 2, 32));
		//ASSERT(rabin_miller_prime_test(c, &rng, 2, 32));
	}

	TEST "RSA genprime 2048" {

		IF#(0)
		{
			seed: U1#[?](U1 1, U1 2, U1 3, U1 8, U1 3);// U1 CPU_COUNTER, RANDOM U1);
		

			prime: {[#3840]BitInt, U4, U8};
			now ::= NOW;
			IF#(0)
			{
				rng: sha3::State ();
				rng.update(seed);
				rng.shake_start();
				number: [#2048]BitInt;
				k_bits ::= 2048;
				rng.shake_output(number.bytes());
				number.Digits[0] |= 1;
				number.Digits[##number.Digits-1] |= 1<<31;

				number += 2*1040;
				prime.(0) := number;
				prime.(1) := 1040;

				os::term::Print_v("\nTesting ", std::io::format::dec(prime.(0).last1pos()+1), "-bit prime: ");
				FOR(prime.(0).Digits; --) os::term::Print_v(std::io::format::hex_x(IT, 8, FALSE));
				os::term::PrintLine_v();
				ASSERT(rabin_miller_prime_test(number, &rng, 2, 64));
			}

			{
				rng: sha3::State ();
				rng.update(seed);
				rng.shake_start();
				prime := [#3840]generate_prime(rng, 0);
			}
			end ::= NOW;

			os::term::Print_v("\nFound ", std::io::format::dec(prime.(0).last1pos()+1), "-bit prime (attempt #", std::io::format::dec(prime.(1)), ", ", std::io::format::dec((end-now) / MEGA), "ms, ", std::io::format::dec(prime.(2)/MEGA), "ms): ");
			FOR(prime.(0).Digits; --) os::term::Print_v(std::io::format::hex_x(IT, 8, FALSE));
			os::term::PrintLine_v();
		}
	}

	TEST "RSA" {
		s: sha3::State;
		FOR(4) s.Buffer[IOTA] := RANDOM U8;
		s.Progress := 32;
		s.shake_start();

		pub: [#3072]RsaPub (BARE);
		priv: [#3072]RsaPriv (BARE);
		allowed_e: U4[?] (U4 3,U4 5,U4 7, U4 17, U4 65537);

	FOR(1)
	{
		rsa_keygen(&pub, &priv, allowed_e[#], s);


		raw_label: U1#[?] (U1'l', U1'a', U1'b');//, U1'e', U1'l');

		raw_msg: U1#[?] (U1'h', U1'e', U1'l', U1'l', U1'o');
		msg: [#3072]BitInt;
		cipher: [#3072]BitInt;
		msg2: [#3072]BitInt;

		{
			oaep: crypto::padding::OAEPParams := :variable(SIZEOF(# msg), 4, ##raw_label);
			crypto::padding::oaep_mask(msg.bytes(), oaep, NULL, raw_msg, s);
			pub.encrypt(msg, &cipher);
			priv.decrypt(pub, cipher, &msg2);
			ASSERT(msg == msg2);
			r ::= crypto::padding::oaep_unmask(msg2.bytes(), oaep);
			ASSERT(r);
			ASSERT(##r.Label == ##raw_label);
			FOR(r.Label) ASSERT(0 == IT);
			ASSERT(##r.Message == ##raw_msg);
			ASSERT(&r.Message[0] == &msg2.bytes()[0]);

			FOR(r.Message) ASSERT(IT == raw_msg[IOTA]);
		}

		{
			oaep: crypto::padding::OAEPParams := :variable(SIZEOF(# msg), 4, ##raw_label);
			crypto::padding::oaep_mask(msg.bytes(), oaep, raw_label, raw_msg, s);
			pub.encrypt(msg, &cipher);
			priv.decrypt(pub, cipher, &msg2);
			ASSERT(msg == msg2);
			r ::= crypto::padding::oaep_unmask(msg2.bytes(), oaep);
			ASSERT(r);
			ASSERT(##r.Label == ##raw_label);
			FOR(r.Label) ASSERT(raw_label[IOTA] == IT);
			ASSERT(##r.Message == ##raw_msg);
			ASSERT(&r.Message[0] == &msg2.bytes()[0]);

			FOR(r.Message) ASSERT(IT == raw_msg[IOTA]);
		}
	}
	}
}
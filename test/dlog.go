package main

import (
	"crypto/rand"
	"fmt"
	"math/big"
)

func main() {
	s, _ := rand.Prime(rand.Reader, 128)
	t, _ := rand.Prime(rand.Reader, 120)

	r := big.NewInt(1)

	l := 1
	for {
		if l > 2048 {
			panic("l exceeded")
		}

		r.Add(r, t)
		r.Add(r, t)

		if r.ProbablyPrime(128) {
			break
		}

		l += 1
	}

	rs := new(big.Int).Mul(r, s)
	one := big.NewInt(1)
	s_mod := new(big.Int).Exp(s, new(big.Int).Sub(r, one), rs)
	r_mod := new(big.Int).Exp(r, new(big.Int).Sub(s, one), rs)

	p0 := new(big.Int).Add(rs, s_mod)
	p0.Sub(p0, r_mod)
	p0.Mod(p0, rs)

	if p0.Bit(0) == 0 {
		p0.Add(p0, rs)
	}

	k := 0
	p := new(big.Int).Set(p0)
	for {
		if k > 2048 {
			panic("k exceeded")
		}

		if p.ProbablyPrime(128) {
			break
		}

		k += 1

		p.Add(p, rs)
		p.Add(p, rs)
	}

	fmt.Printf("s: %v (%v bit)\n", s, s.BitLen())
	fmt.Printf("t: %v (%v bit)\n", t, t.BitLen())
	fmt.Printf("L: %v\n", l)
	fmt.Printf("r: %v (%v bit)\n", r, r.BitLen())
	fmt.Printf("rs: %v\n", rs)
	fmt.Printf("p0: %v\n", p0)
	fmt.Printf("s_mod: %v\n", s_mod)
	fmt.Printf("r_mod: %v\n", r_mod)
	fmt.Printf("K: %v\n", k)
	fmt.Printf("p: %v (%v bit)\n", p, p.BitLen())
}

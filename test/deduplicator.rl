INCLUDE 'std/valpool'

::std TEST "Deduplicator" {

	pool: INT-std::ValPool := :buckets(100);

	a: INT-std::Val := 5;
	b: INT-std::Val := 5;
	c: INT-std::Val := 6;

	ASSERT(a.ptr() != b.ptr());

	d ::= pool.dedup(a);
	ASSERT(d.ptr() == a.ptr());

	b := pool.dedup(&&b);
	ASSERT(b.ptr() == a.ptr());

	c_old ::= c.ptr();
	c := pool.dedup(&&c);
	ASSERT(c.ptr() == c_old);
	ASSERT(c.ptr() != a.ptr());

	ASSERT(c.ptr() == pool.dedup_instance(6).ptr());

	vpool: INT-std::Vec -std::ValPool := :buckets (100);

	v2 ::= vpool.dedup(<INT-Vec>());
	v2_ ::= vpool.dedup(<INT-Vec>());
	ASSERT(v2.ptr() == v2_.ptr());
	std::io::write(&std::io::out, "[", :addr(v2->data()), ", ", :dec(##*v2), ":", :dec(v2->capacity()), "] @ ", :addr(v2.ptr()), "\n");

	{
		default: INT-Vec-Val;
		manual: INT-Vec-Val := <INT-Vec>();
		ASSERT(! (*default <> *manual));
	}
	v1 ::= vpool.dedup_instance(<INT-Vec>());
	v1_ ::= vpool.dedup_instance(<INT-Vec>());

	std::io::write(&std::io::out, "[", :addr(v1->data()), ", ", :dec(##*v1), ":", :dec(v1->capacity()), "] @ ", :addr(v1.ptr()), "\n");
	ASSERT(v1.ptr() == v1_.ptr());
	ASSERT(! (v1 <> v1_));

	ASSERT(! (*v1 <> *v2));

	cmp ::= hash(<INT-Vec>());
	ASSERT(hash(v1.shared()) == hash(v2.shared()));
	ASSERT(hash(*v1) == cmp);
	ASSERT(hash(v1.shared()) == cmp);
	ASSERT(hash(*v2) == cmp);
	ASSERT(hash(v2.shared()) == cmp);
	ASSERT(v1.ptr() == v2.ptr());

	ASSERT(!vpool.gc(&&v1));
	ASSERT(!vpool.gc(&&v1_));
	ASSERT(!vpool.gc(&&v2));
	ASSERT(vpool.gc(&&v2_));
}
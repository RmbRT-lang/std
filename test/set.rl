INCLUDE "../std/set"

TYPE IntVectorSet := std::[INT]NatVectorSet;

::std
{
	TEST "VectorSet::empty"
	{
		set: IntVectorSet;
		ASSERT(set.empty());
		set.insert(5);
		ASSERT(!set.empty());
		set.remove(5);
		ASSERT(set.empty());
	}

	TEST "VectorSet::insert"
	{
		set: IntVectorSet;
		ASSERT(set.insert(6) && !set.insert(6));
		ASSERT(set.insert(7) && !set.insert(7));
	}

	TEST "VectorSet::remove"
	{
		set: IntVectorSet;
		set.insert(5);
		ASSERT(set.remove(5) && !set.remove(5));
		set.insert(5);
		set.insert(6);
		set.insert(7);
		ASSERT(set.remove(6) && !set.remove(6));
		ASSERT(set.remove(7) && !set.remove(7));
		ASSERT(set.remove(5) && !set.remove(5));
	}

	TEST "VectorSet::find"
	{
		set: IntVectorSet;
		l: IntVectorSet::Location;
		ASSERT(!set.find(5) && !set.find(5, &l));
		set.insert(7);
		ASSERT(set.find(7) && set.find(7, &l));
		set.remove(7);
		ASSERT(!set.find(7) && !set.find(7, &l));
		ASSERT(!set.find(4) && !set.find(4, &l));
	}

	TEST "VectorSet::Iterator"
	{
		set: IntVectorSet;
		set.insert(1);
		set.insert(0);
		set.insert(3);

		i ::= set.start();
		ASSERT(i && i.get() == 0);
		i.next();
		ASSERT(i && i.get() == 1);
		i.next();
		ASSERT(i && i.get() == 3);
		i.next();
		ASSERT(!i);
	}
}
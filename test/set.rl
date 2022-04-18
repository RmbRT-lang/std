INCLUDE "../std/set"

TYPE IntVecSet := std::[INT]NatVecSet;

::std
{
	TEST "VecSet::empty"
	{
		set: IntVecSet;
		ASSERT(set.empty());
		set += 5;
		ASSERT(!set.empty());
		set.remove(5);
		ASSERT(set.empty());
	}

	TEST "VecSet::insert"
	{
		set: IntVecSet;
		ASSERT(set.insert(6) && !set.insert(6));
		ASSERT(set.insert(7) && !set.insert(7));
	}

	TEST "VecSet::remove"
	{
		set: IntVecSet;
		set += 5;
		ASSERT(set.remove(5) && !set.remove(5));
		set += 5;
		set += 6;
		set += 7;
		ASSERT(set.remove(6) && !set.remove(6));
		ASSERT(set.remove(7) && !set.remove(7));
		ASSERT(set.remove(5) && !set.remove(5));
	}

	TEST "VecSet::find"
	{
		set: IntVecSet;
		l: IntVecSet::Location;
		ASSERT(!set.find(5) && !set.find_loc2(5, &l));
		set += 7;
		ASSERT(set.find(7) && set.find_loc2(7, &l));
		set.remove(7);
		ASSERT(!set.find(7) && !set.find_loc2(7, &l));
		ASSERT(!set.find(4) && !set.find_loc2(4, &l));
	}

	TEST "VecSet::Iterator"
	{
		set: IntVecSet;
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
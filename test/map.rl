INCLUDE "../std/map"
INCLUDE "set.rl"

TYPE IntBoolMap := std::[INT, BOOL]NatMap;

::std
{
	TEST "Map::empty"
	{
		map: IntBoolMap;
		ASSERT(map.empty());
		map.insert(5, TRUE);
		ASSERT(!map.empty());
		del: BOOL := FALSE;
		ASSERT(map.pop(5, &del));
		ASSERT(del);
		ASSERT(map.empty());
	}

	TEST "Map::insert"
	{
		map: IntBoolMap;
		ASSERT(map.insert(6, TRUE) && !map.insert(6, FALSE));
		ASSERT(map.insert(7, FALSE) && !map.insert(7, TRUE));
		i6 ::= map.find(6);
		i7 ::= map.find(7);
		ASSERT(i6);
		ASSERT(i7);
		ASSERT(*i6 == TRUE);
		ASSERT(*i7 == FALSE);
	}

	TEST "VectorSet::remove"
	{
		map: IntBoolMap;
		map.insert(5, TRUE);
		ASSERT(map.remove(5) && !map.remove(5));
		map.insert(5, FALSE);
		map.insert(6, TRUE);
		map.insert(7, FALSE);
		ASSERT(map.remove(6) && !map.remove(6));
		ASSERT(map.remove(7) && !map.remove(7));
		ASSERT(map.remove(5) && !map.remove(5));
	}

	TEST "VectorSet::find"
	{
		map: IntBoolMap;
		l: IntBoolMap::Location;
		ASSERT(!map.find(5) && !map.find_loc2(5, &l));
		map.insert(7, TRUE);
		ASSERT(map.find(7) && map.find_loc2(7, &l));
		map.remove(7);
		ASSERT(!map.find(7) && !map.find_loc2(7, &l));
		ASSERT(!map.find(4) && !map.find_loc2(4, &l));
	}

	TEST "VectorSet::Iterator"
	{
		map: IntBoolMap;
		map.insert(1, TRUE);
		map.insert(0, FALSE);
		map.insert(3, TRUE);

		i ::= map.start();
		ASSERT(i && i.get() == (0, FALSE));
		i.next();
		ASSERT(i && i.get() == (1, TRUE));
		i.next();
		ASSERT(i && i.get() == (3, TRUE));
		i.next();
		ASSERT(!i);
	}
}
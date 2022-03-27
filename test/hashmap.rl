INCLUDE "../std/hashmap"

TYPE IntBoolHashMap := std::[INT, BOOL]HashMap;

::std
{
	TEST "HashMap::empty"
	{
		map: IntBoolHashMap;
		ASSERT(map.empty());
		map.insert(5, TRUE);
		ASSERT(!map.empty());
		del: BOOL := FALSE;
		ASSERT(map.pop(5, &del));
		ASSERT(del);
		ASSERT(map.empty());
	}

	TEST "HashMap::insert"
	{
		map: IntBoolHashMap;
		ASSERT(map.insert(6, TRUE) && !map.insert(6, FALSE));
		ASSERT(map.insert(7, FALSE) && !map.insert(7, TRUE));
		i6 ::= map.find(6);
		i7 ::= map.find(7);
		ASSERT(i6);
		ASSERT(i7);
		ASSERT(*i6 == TRUE);
		ASSERT(*i7 == FALSE);
	}

	TEST "HashMap::remove"
	{
		map: IntBoolHashMap;
		map.insert(5, TRUE);
		ASSERT(map.remove(5) && !map.remove(5));
		map.insert(5, FALSE);
		map.insert(6, TRUE);
		map.insert(7, FALSE);
		ASSERT(map.remove(6) && !map.remove(6));
		ASSERT(map.remove(7) && !map.remove(7));
		ASSERT(map.remove(5) && !map.remove(5));
	}

	TEST "HashMap::find"
	{
		map: IntBoolHashMap;
		l: IntBoolHashMap::Location;
		ASSERT(!map.find(5) && !map.find_loc2(5, &l));
		map.insert(7, TRUE);
		ASSERT(map.find(7) && map.find_loc2(7, &l));
		map.remove(7);
		ASSERT(!map.find(7) && !map.find_loc2(7, &l));
		ASSERT(!map.find(4) && !map.find_loc2(4, &l));
	}
}
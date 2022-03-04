INCLUDE 'std/hashset'

::std::test::hash_set
{
	Point
	{
		X: INT;
		Y: INT;

		{};
		{x: INT, y: INT}: X(x), Y(y);
	}

	TEST "insert-remove"
	{
		set: Point-HashSet;
		ASSERT(!set.has((0,1)));
		ASSERT(set.insert((0,1)));
		ASSERT(set.has((0,1)));
		ASSERT(set.remove((0,1)));
		ASSERT(!set.remove((0,1)));
	}
}
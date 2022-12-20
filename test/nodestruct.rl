INCLUDE 'std/nodestruct'

::std::nodestruct_test
{
	Type
	{
		STATIC Dtor: BOOL;
		DESTRUCTOR { Dtor := TRUE; }
	}

	TEST "NoDestruct"
	{
		x: Type-NoDestruct;

		x.~;
		ASSERT(!x->Dtor);
		x->~;
		ASSERT(x->Dtor);
	}
}
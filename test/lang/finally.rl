::lang::exception TEST "finally: thrown"
{
	x: INT(0);

	TRY THROW;
	CATCH() {;}
	FINALLY x := 5;

	ASSERT(x == 5);
}

::lang::exception TEST "finally: not thrown"
{
	x: INT(0);

	TRY {;}
	FINALLY x := 5;

	ASSERT(x == 5);
}
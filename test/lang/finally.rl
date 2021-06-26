::lang::exception TEST "finally: thrown and caught"
{
	x: INT(0);

	TRY THROW;
	CATCH() {;}
	FINALLY x := 5;

	ASSERT(x == 5);
}

::lang::exception TEST "finally: thrown and not caught"
{
	x: INT(0);

	TRY
	{
		TRY THROW;
		FINALLY x := 5;
	} CATCH() {;}

	ASSERT(x == 5);
}

::lang::exception TEST "finally: not thrown"
{
	x: INT(0);

	TRY {;}
	FINALLY x := 5;

	ASSERT(x == 5);
}
INCLUDE 'std/buffer2d'
INCLUDE 'std/dyn2d'

::std::test_2d
{
	TEST "Dyn2D, Buffer2D[x,y]"
	{
		b: INT-Dyn2D := :new(3, 2);

		b![0, 0] := 0;
		b![1, 0] := 1;

		ASSERT(b![0,0] == 0);
		ASSERT(b![1,0] == 1);
		TRY { b![3, 0]; DIE; } CATCH(err::IndexOutOfRange) {;}
	}

	TEST "Buffer2D::slice"
	{
		b: INT-Dyn2D := :new(3, 3);
		/// (1, 1-2)
		s ::= b!.slice((1, 1), (1, 2));

		ASSERT(&s[0, 0] == &b![1,1]);
		ASSERT(&s[0, 1] == &b![1,2]);
	}

	TEST "Buffer2D::row"
	{
		b: INT-Dyn2D := :new(3, 4);
		FOR(y ::= 0; y < b!.H; y++)
		{
			row ::= b!.row(y);
			FOR(x ::= 0; x < b!.W; x++)
				ASSERT(&row[x] == &b![x,y]);
		}
	}
}
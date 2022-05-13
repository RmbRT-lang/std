
::lang::clocal
{
	Class
	{
		TYPE SubType := VOID;

		f(SubType*) SubType { ; }

		<BOOL> { = FALSE; }
		<INT> := 0;
		lel() ? := 5;

		f(t: THIS&) ? := t.lel();
	}
}
::std::lang::auto_dyn_cast
{
	Base VIRTUAL {}
	Derived -> Base {}

	TEST "auto dyn cast"
	{
		d: Derived;
		b: Base & := d;
		dr: Derived & := >>b;
		dr2: Derived && := >>&&b;
	}
}
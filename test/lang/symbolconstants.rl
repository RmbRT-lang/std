::lang
{
	n: :null;
	TYPE x := :cstring;
	fn(:null) INT := 0;

	TEST "symbol constants"
	{
		ASSERT(fn(:null) == 0);
		ASSERT(fn(n) == 0);
	}


	[T:TYPE] template_symbol(a: {:tpl.T!, INT&&}) INT := a.(1);
	TEST "templated symbol constants"
	{
		ASSERT(template_symbol(:tpl.INT(5)) == 5);
	}

	TemplateInit
	{
		Type: CHAR #\;
		X: INT;
		[T:TYPE]
		:ctor.T!{x: INT}:
			Type := TYPE TYPE(T),
			X := x;
	}

	TEST "templated symbol constant constructor variants"
	{
		v: TemplateInit := :ctor.BOOL(32);
		ASSERT(v.Type == TYPE TYPE(BOOL));
		ASSERT(v.X == 32);
	}
}
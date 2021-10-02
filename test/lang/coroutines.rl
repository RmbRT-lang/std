::lang::coroutine
{
	F
	{
		lel() @INT := 5;
	}

	testfn() @ VOID
	{
		f: F;
		h ::= f.lel();
		ASSERT(5 == <-h);
		RETURN;
	}

	TEST "await"
	{
		testfn().get();
	}

	aborted_fn(done: BOOL. &) @ VOID
	{
		...0.1;
		done := :>(TRUE);
		RETURN;
	}

	call_aborted_fn(done: BOOL. &) @ VOID
	{
		// This should automatically call co_await.
		// Any function called from within a coroutine should be awaited.
		// - What about regular functions returning awaitables?
		<-aborted_fn(done);
		RETURN;
	}

	TEST "yield coroutine await"
	{
		done: BOOL. := FALSE;
		call_aborted_fn(done).get();
		ASSERT(done(:?));
	}


	wait_set(
		wait: BOOL. &,
		started: BOOL. &
	) VOID
	{
		ASSERT(!wait(:?));

		started := :>(TRUE);
		WHILE(!wait(:<))
			...;
	}

	// Communicates between two threads via atomic bools.
	TEST "parallelism"
	{
		finish: BOOL. := FALSE;
		started: BOOL. := FALSE;

		// Start thread waiting for `finish` to be set.
		wait ::= ^wait_set(finish, started);

		// Wait until thread started.
		WHILE(!started(:<))
			...;

		ASSERT(!wait[0.1]);
		// Signal thread to finish.
		finish := :>(TRUE);
		// Await thread.
		wait(1.0);
	}
}
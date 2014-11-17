#TIME	NODE(S)	DEVICE	MODE	ELEMENT		HANDLER		VALUE
240	node2 	ath0	write	dhtstoragetest  test		write 100
242	node25 	ath0	write	dhtstoragetest  test		read 100
244	node25 	ath0	read	dhtstoragetest  test
246	node25 	ath0	write	dhtstoragetest  test		read 200
247	node25 	ath0	read	dhtstoragetest  test
248	node2 	ath0	write	dhtstoragetest  test		write foo bar
249	node25 	ath0	write	dhtstoragetest  test		read foo
250	node25 	ath0	write	dhtstoragetest  test		append foo bar
251	node25 	ath0	write	dhtstoragetest  test		read foo
255	node25 	ath0	read	dhtstoragetest  test
258	node2 	ath0	read	dhtstoragetest  stats
258	node25 	ath0	read	dhtstoragetest  stats

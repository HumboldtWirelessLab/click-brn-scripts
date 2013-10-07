#TIME	NODE(S)	DEVICE	MODE	ELEMENT		HANDLER		VALUE
240	sk2 	ath0	write	dhtstoragetest  test		write 100
242	sk4 	ath0	write	dhtstoragetest  test		read 100
244	sk4 	ath0	read	dhtstoragetest  test
246	sk4 	ath0	write	dhtstoragetest  test		read 200
247	sk4 	ath0	read	dhtstoragetest  test
248	sk2 	ath0	write	dhtstoragetest  test		write foo bar
249	sk4 	ath0	write	dhtstoragetest  test		read foo
250	sk4 	ath0	read	dhtstoragetest  test
258	sk2 	ath0	read	dhtstoragetest  stats
258	sk4 	ath0	read	dhtstoragetest  stats

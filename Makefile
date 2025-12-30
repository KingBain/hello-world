hello:
	gcc -static -o $@ hello.c

install:
	install -Dm755 hello ${DESTDIR}/usr/bin/hello

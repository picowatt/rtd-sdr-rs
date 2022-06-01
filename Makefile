build-lib:
	docker build -t librtlsdr .

build-lib-nc:
	docker build --no-cache -t librtlsdr .

compile-lib:
	docker run --name librtlsdr librtlsdr
	docker cp librtlsdr:/tmp/librtlsdr-rs ./
	docker rm librtlsdr
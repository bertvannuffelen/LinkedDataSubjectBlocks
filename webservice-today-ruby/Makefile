VERSION:=`cat ../VERSION`
PUBLISHEDIMAGE:=`cat ../PUBLISHED`

build:
	docker build -f Dockerfile.ruby -t bertvannuffelen/ldsb:${VERSION} .

run:
	docker run -d --rm --name ldsb -p 80:80 -v ${CURDIR}:/data bertvannuffelen/ldsb:${VERSION} 

test:
	docker run -it --rm --name ldsb -p 80:80 bertvannuffelen/ldsb:${VERSION} bash

stop:
	docker stop ldsb || true
	docker rm ldsb || true


clean: stop
	docker rmi $(shell docker images -q bertvannuffelen/ldsb ) || true



publish:
	docker tag bertvannuffelen/ldsb:${VERSION} ${PUBLISHEDIMAGE}:${VERSION}
	docker push ${PUBLISHEDIMAGE}:${VERSION}


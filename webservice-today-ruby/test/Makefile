VERSION:=`cat VERSION`

build:
	docker build -f Dockerfile.Caddy -t bertvannuffelen/testserver:latest .
	docker build -f Dockerfile -t test:${VERSION} .


clean:
	docker rmi bertvannuffelen/testserver:latest
	docker rmi test:${VERSION}


example: 
	docker run --rm --name tls -e NR_DOMAINS=1 -e DOMAIN1=test.com -e EMAIL1=x@x.com -e APP_SERVER1=localhost:23 test:${VERSION}

run:
	docker-compose -f docker-compose.yml up -d

stop: 
	docker-compose -f docker-compose.yml down

test:
	./doc.test.sh

logs:
	docker-compose -f docker-compose.yml logs



NAME = swingdevelopment/dhc-stunnel
SHA1 = $(shell git rev-parse HEAD)

build:
	docker build -t $(NAME):$(SHA1) .

tag_latest:
	docker tag $(NAME):$(SHA1) $(NAME):latest

test:
	docker run $(DOCKER_RUN_TEST_PARAMS) \
					-e STUNNEL_SERVICE_ACCEPT_PORT=11999 \
					-e STUNNEL_SERVICE_CONNECT_HOST=test \
					-e STUNNEL_SERVICE_CONNECT_PORT=11999 \
					$(NAME):$(SHA1) echo "No tests here."

push:
	docker push $(NAME):$(SHA1)

push_latest:
	docker push $(NAME):latest

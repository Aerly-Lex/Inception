NAME =	inception
COMPOSE := docker-compose -f ./srcs/docker-compose.yml

up: build
	@echo "Building and starting all containers..."
	@$(COMPOSE) up -d

build:
	@mkdir -p /home/dscheffn/data/mariadb
	@mkdir -p /home/dscheffn/data/wordpress
	@$(COMPOSE) build --no-cache

down:
	@echo "Stopping and removing all containers..."
	@$(COMPOSE) down

stop:
	@echo "Stopping containers..."
	@$(COMPOSE) stop $(docker ps -qa)

start:
	@echo "Starting containers..."
	@$(COMPOSE) start

status:
	@echo "Showing status of containers..."
	@docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

clean: down
	@echo "Stopping and removing all containers..."
	@docker volume rm $$(docker volume ls -q) 2>/dev/null || true
	@docker rmi -f $$(docker images -qa) 2>/dev/null || true

fclean: clean
	@echo "Performing system-wide cleanup of Docker resources..."
	@docker system prune -f

remove:
	@echo "Removing project data and docker files..."
	@sudo rm -rf ~/data/mariadb ~/data/wordpress
	@if [ -n "$$(docker ps -qa)" ]; then docker stop $$(docker ps -qa); fi
	@if [ -n "$$(docker ps -qa)" ]; then docker rm $$(docker ps -qa); fi
	@if [ -n "$$(docker images -qa)" ]; then docker rmi -f $$(docker images -qa); fi
	@if [ -n "$$(docker volume ls -q)" ]; then docker volume rm $$(docker volume ls -q); fi
	@if [ -n "$$(docker network ls -q)" ]; then docker network rm $$(docker network ls -q) 2>/dev/null || true; fi

.PHONY: up down stop start status clean fclean remove
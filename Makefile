NAME =	inception
COMPOSE := docker-compose -f ./srcs/docker-compose.yml

#ensure-dirs:
#	@echo "Ensuring data directories exist and rights..."
#	@mkdir -p ~/docker_data/mariadb ~/docker_data/wordpress
#	@sudo chown -R $(USER):$(USER) ~/docker_data
#	@sudo chmod -R 755 ~/docker_data

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
#	@echo "Stopping containers..."
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

reset: clean
	@echo "Resetting project data..."
	@sudo rm -rf ~/data/mariadb ~/data/wordpress
#	@rm -rf ~/docker_data/mariadb ~/docker_data/wordpress
#	@mkdir -p ~/docker_data/mariadb ~/docker_data/wordpress
#	@sudo chown -R $(USER):$(USER) ~/docker_data
#	@sudo chmod -R 755 ~/docker_data


remove:
	@sudo rm -rf ~/data/mariadb ~/data/wordpress
	@if [ -n "$$(docker ps -qa)" ]; then docker stop $$(docker ps -qa); fi
	@if [ -n "$$(docker ps -qa)" ]; then docker rm $$(docker ps -qa); fi
	@if [ -n "$$(docker images -qa)" ]; then docker rmi -f $$(docker images -qa); fi
	@if [ -n "$$(docker volume ls -q)" ]; then docker volume rm $$(docker volume ls -q); fi
	@if [ -n "$$(docker network ls -q)" ]; then docker network rm $$(docker network ls -q) 2>/dev/null || true; fi

.PHONY: up down stop start status clean fclean reset remove
# DC_FILE := srcs/docker-compose.yml

COMPOSE := docker-compose -f ./srcs/docker-compose.yml

ensure-dirs:
	@mkdir -p /home/dscheffn/data /home/dscheffn/data/mariadb /home/dscheffn/data/wordpress
# @mkdir -p /Users/dscheffn/Documents/data /Users/dscheffn/Documents/data/mariadb /Users/dscheffn/Documents/data/wordpress

up: ensure-dirs
	@echo "Building and starting all containers..."
	@$(COMPOSE) up --build -d

down:
	@echo "Stopping and removing all containers..."
	@$(COMPOSE) down

stop:
	@echo "Stopping containers..."
	@$(COMPOSE) stop

start: ensure-dirs
	@echo "Starting containers..."
	@$(COMPOSE) start

status:
	@echo "Showing status of containers..."
	@docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

clean: clean-containers clean-images clean-volumes

clean-containers:
	@echo "Stopping and removing all containers..."
	@docker stop $$(docker ps -qa) 2>/dev/null || true
	@docker rm $$(docker ps -qa) 2>/dev/null || true

clean-images:
	@echo "Removing all images..."
	@docker rmi -f $$(docker images -qa) 2>/dev/null || true

clean-volumes:
	@echo "Removing all volumes..."
	@docker volume rm $$(docker volume ls -q) 2>/dev/null || true

fclean: down clean
	@echo "Performing system-wide cleanup of Docker resources..."
	@docker system prune -f

reset: fclean
	@echo "Resetting project data..."
	@rm -rf /home/dscheffn/data/mariadb /home/dscheffn/data/wordpress
	@mkdir /home/dscheffn/data/mariadb /home/dscheffn/data/wordpress
# @rm -rf /Users/dscheffn/Documents/data/mariadb /Users/dscheffn/Documents/data/wordpress
# @mkdir /Users/dscheffn/Documents/data/mariadb /Users/dscheffn/Documents/data/wordpress

.PHONY: up down stop start status clean clean-images clean-volumes fclean reset ensure-dirs
run:
	@echo "Running main.go..."
	@go run main.go


start_db:
	@echo "Stopping postgres..."
	@bash ../stop_postgres.sh
	@echo "Starting postgres..."
	@docker-compose --env-file ../.env up 

start_without_stop:
	@echo "Starting postgres..."
	@docker-compose --env-file ../.env up

tidy:
	@echo "Tidy up libs..."
	@go mod tidy 

clear:
	@echo "Clearing up database..."
	@docker-compose down --volumes
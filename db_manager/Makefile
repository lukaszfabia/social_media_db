run:
	@echo "Running main.go..."
	@go run main.go


docker-run:
	@echo "Starting database..."
	@bash ../stop_postgres.sh
	@docker-compose --env-file ../.env up 

docker-down:
	@echo "Starting database..."
	@bash ../stop_postgres.sh
	@docker-compose down 

tidy:
	@echo "Tidy up libs..."
	@go mod tidy 

clear:
	@echo "Clearing up database..."
	@docker-compose down --volumes
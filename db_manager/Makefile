run:
	@echo "Running main.go..."
	@go run main.go


start_db:
	@echo "Starting database..."
	@bash ../stop_postgres.sh
	@docker-compose --env-file ../.env up 

tidy:
	@echo "Tidy up libs..."
	@cd db_manager
	@go mod tidy 

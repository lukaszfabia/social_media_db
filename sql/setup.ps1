# Check if Docker is installed
if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Host "Docker is not installed. Installing Docker Desktop..."
    winget install Docker.DockerDesktop
    Write-Host "Docker Desktop installation completed. Please restart your system if Docker is still not recognized."
    Start-Sleep -Seconds 10
    exit
}

# Output Docker and Docker Compose versions
Write-Host "Docker version: $(docker --version)"
Write-Host "Docker Compose version: $(docker-compose --version)"

# Check if .env file exists in the current directory
$envFile = "$PWD\.env"
if (Test-Path $envFile) {
    Write-Host ".env file found. Starting Docker Compose..."
    docker-compose --env-file $envFile up
} else {
    # Create .env file and populate with default values
    Write-Host ".env file not found. Creating .env file..."
    $user = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
    $content = "POSTGRES_USER=$user`nPOSTGRES_PASSWORD=$user`nPOSTGRES_DB=`nPGADMIN_DEFAULT_EMAIL=`nPGADMIN_DEFAULT_PASSWORD=`n"
    $content | Out-File -FilePath $envFile -Encoding UTF8
    Write-Host ".env file created at $PWD. Please fill in the necessary environment variables and re-run the script."
}

# Social media Database

## About files

### docker-compose.yml

Contains all you need to set your db locally in the container. You can run it in two different ways. Run it manually or use dedicated script.

Change privilages for `setup.sh` file.

```bash
sudo chmod +x setup.sh
```

If port is taken, you can

```bash
sudo lsof -i [port]
```

And just

```bash
sudo kill [pid]
```

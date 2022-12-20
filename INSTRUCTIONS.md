## Development Setup

1. Use Docker Compose for development.

    - On **MacOS** you just have to download & install the Docker image.
    - On  **Ubuntu** `sudo apt-get install docker-engine` after adding the Docker repos.

2. Run `docker-compose build` for:
    - Run docker-compose
    - Build the containers
    - Run the containers in the background

3. Run `docker-compose up -d` for:
    - Run docker-compose
    - Run the containers in the background

4. Run `docker-compose run cli rake db:setup && docker-compose run cli rake db:seed` for:
    - Run the rake command to create the database and seeds

You can reach the system via [http://localhost:3000](http://localhost:3000) when the containers are running.
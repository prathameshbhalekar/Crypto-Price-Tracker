![CRYPTO PRICE TRACKER (1)](https://user-images.githubusercontent.com/33856767/207240188-9d9e59e2-9e35-4f68-806c-c90b77dc9df3.png)

Crypto Price Tracker is an API which allows users to set alerts on
certain crypto tokens. It sends email notification to the user when the
price of the token hits a certain trigger value.

## Install

### Fork

Create your own copy of the project on GitHub. You can do this by clicking the Fork button  on the top right corner of the landing page of the repository.

### Clone

Note: For this you need to install [git](https://git-scm.com/downloads) on your machine

```bash
$ git clone https://github.com/<YOUR_GITHUB_USER_NAME>/Crypto-Price-Tracker
```
where YOUR_GITHUB_USER_NAME is your GitHub handle.

### Setup the .ENV file
Add environment variables

```bash
DB_PASSWORD: <POSTGRES PASSWORD>

REDIS_PASSWORD: <REDIS PASSWORD>

JWT_SECRET: <JWT SECRET>

EMAIL_ID: <EMAIL ID>
EMAIL_PASSWORD: <PASSWORD>
```

Note: [Directions to generate email password](https://hotter.io/docs/email-accounts/app-password-gmail/)

### Run Docker Compose
```bash
$ docker-compose up -d --build
```
Note: For this you need to install [docker](https://docs.docker.com/engine/install/) on your machine

### You are up and running on port 8080!

## Documentation
Postman docs link: https://documenter.getpostman.com/view/13627665/2s8YzUwgMu


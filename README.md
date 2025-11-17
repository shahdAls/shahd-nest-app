# NestJS + Ionic React App

This project packages an **Ionic React app** served by **NestJS** into a Docker image and provides instructions to run it using Docker Compose.

---

## Steps to Run Locally

### 1. Create the Ionic React App

Install the Ionic CLI globally:

```bash
npm install -g @ionic/cli
```

Create a blank React app:

```bash
ionic start shahd-ionic-app blank --type=react
```

Navigate to the app folder and serve it locally:

```bash
cd shahd-ionic-app
ionic serve
```

>  The app should open in your browser.

---

### 2. Build the Ionic React App

```bash
ionic build
```

This generates a `dist` folder containing the production build.

---

### 3. Create the NestJS App

Install NestJS CLI globally:

```bash
npm i -g @nestjs/cli
```

Create a new NestJS app:

```bash
nest new shahd-nest-app
```

---

### 4. Copy Ionic Build into NestJS

* Copy the contents of `shahd-ionic-app/dist` into a folder called `client` inside `shahd-nest-app`.

---

### 5. Serve the React App from NestJS

Install the static serve module:

```bash
npm install @nestjs/serve-static
```

Modify `src/app.module.ts`:

The problem here is that NestJS doesn't automatically see the client folder and
the code inside your React app. You need to use a static server to host it.

ServeStaticModule → serves as a local host for static files:
```typescript
import { ServeStaticModule } from '@nestjs/serve-static';
import { join } from 'path';

@Module({
  imports: [
    ServeStaticModule.forRoot({
      rootPath: join(__dirname, '..', 'client'), // points to the client folder
    }),
    // ...other modules
  ],
  // ...
})
export class AppModule {}
```

> This allows NestJS to serve the built React app.

---

### 6. Create Docker Image

Create a `Dockerfile` at the root of the NestJS project:

```dockerfile
FROM node:20-alpine

WORKDIR /app

COPY package*.json ./
RUN npm install --production

COPY . .

RUN npm run build

EXPOSE 3000
CMD ["node", "dist/main"]
```

Build and run the Docker image:

```bash
docker build -t shahd/nest-ionic-app .
docker run -p 3000:3000 shahd/nest-ionic-app
```

---

### 7. Push Docker Image to Docker Hub

Login to Docker Hub:

```bash
docker login
```

Tag your local image to match your Docker Hub repository and push:
```bash
docker tag shahd/nest-ionic-app shahdals/nest-ionic-app:latest
docker push shahdals/nest-ionic-app:latest
```

---

### 8. Run with Docker Compose

Create `docker-compose.yml`:

```yaml
version: '3.9'

services:
  app:
    image: shahdals/nest-ionic-app:latest
    container_name: nest_ionic_app
    ports:
      - "3000:3000" # Map host port 3000 to container port 3000

    restart: always
```

Run the app:

```bash
docker compose up -d
```

> The app will be available at [http://localhost:3000](http://localhost:3000)

---

### 9. Push Code to GitHub

* Make sure to include a proper `.gitignore` (ignore `node_modules`, `dist`, logs, `.env`, etc.).
* Commit all project files and push to your GitHub repository:

```bash
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/shahdAls/shahd-nest-app.git
git push -u origin main
```

---

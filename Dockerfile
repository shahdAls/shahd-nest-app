FROM node:20-alpine

WORKDIR /app

COPY package*.json ./

RUN npm install --production

COPY . .

RUN npm run build
# runing on 3000 port
EXPOSE 3000

CMD ["node", "dist/main"]

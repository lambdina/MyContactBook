FROM alpine:3.14

RUN wget -O - 'https://github.com/elm/compiler/releases/download/0.19.1/binary-for-linux-64-bit.gz' \
    | gunzip -c >/usr/local/bin/elm

RUN chmod +x /usr/local/bin/elm

RUN apk update

RUN apk add --update nodejs npm

WORKDIR /code

COPY ./app /code

RUN npm install --silent

ENV PARCEL_ELM_NO_DEBUG=1

RUN npm run build

CMD ["npm", "start"]

EXPOSE 1234
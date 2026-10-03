FROM golang:1.27.1 AS build

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN mkdir build
RUN CGO_ENABLED=0 go build -o ./build ./...

FROM gcr.io/distroless/static-debian13:nonroot AS runtime

COPY --from=build /app/build /usr/local/bin

ENTRYPOINT ["tesla-http-proxy"]

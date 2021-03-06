FROM golang:1.13 as build

WORKDIR /go/src/github.com/webdevops/azure-devops-exporter

# Get deps (cached)
COPY ./go.mod /go/src/github.com/webdevops/azure-devops-exporter
COPY ./go.sum /go/src/github.com/webdevops/azure-devops-exporter
RUN go mod download

# Compile
COPY ./ /go/src/github.com/webdevops/azure-devops-exporter
RUN make lint
RUN make build
RUN ./azure-devops-exporter --help

#############################################
# FINAL IMAGE
#############################################
FROM gcr.io/distroless/static
COPY --from=build /go/src/github.com/webdevops/azure-devops-exporter/azure-devops-exporter /
USER 1000
ENTRYPOINT ["/azure-devops-exporter"]

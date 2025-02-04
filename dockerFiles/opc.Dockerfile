FROM brew.registry.redhat.io/rh-osbs/openshift-golang-builder:v1.23 AS builder

# Set the working directory
ENV SUBMODULE_OPC=/opc
WORKDIR ${SUBMODULE_OPC}

COPY ./opc .
RUN go build -buildvcs=false -mod=vendor -o /app/opc main.go

WORKDIR /app


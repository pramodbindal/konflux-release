ARG GO_BUILDER=brew.registry.redhat.io/rh-osbs/openshift-golang-builder:v1.23
ARG RUNTIME=registry.access.redhat.com/ubi9/ubi-minimal@sha256:b87097994ed62fbf1de70bc75debe8dacf3ea6e00dd577d74503ef66452c59d6

FROM $GO_BUILDER AS builder

# Set the working directory
ENV SUBMODULE=/opc
WORKDIR ${SUBMODULE}

COPY upstream/opc .
RUN go build -buildvcs=false -mod=vendor -o /app/opc main.go

FROM $RUNTIME
LABEL name="opc" \
      com.redhat.component="opc" \
      io.k8s.display-name="opc" \
      summary="A CLI for OpenShift Pipeline" \
      description="opc makes it easy to work with Tekton resources in OpenShift Pipelines. It is built on top of tkn and tkn-pac and expands their capablities to the functionality and user-experience that is available on OpenShift." \
      io.k8s.description="opc makes it easy to work with Tekton resources in OpenShift Pipelines. It is built on top of tkn and tkn-pac and expands their capablities to the functionality and user-experience that is available on OpenShift." \
      io.openshift.tags="pipelines,tekton,openshift"
WORKDIR /licenses

COPY --from=builder /app/opc /usr/bin
COPY ./upstream/opc/LICENSE .

RUN microdnf install -y shadow-utils && \
    groupadd -r -g 65532 nonroot && useradd --no-log-init -r -u 65532 -g nonroot nonroot
USER 65532

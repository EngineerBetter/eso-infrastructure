FROM golang:1.19-bullseye
COPY external-secrets ./external-secrets

RUN cd external-secrets \
    && go mod download -x \
    && make lint.install \
    && rm -rf ../external-secrets 

RUN go install github.com/mikefarah/yq/v4@latest
RUN go install sigs.k8s.io/controller-runtime/tools/setup-envtest@latest

FROM golang:1.17-bullseye
COPY external-secrets ./external-secrets

RUN cd external-secrets \
    && go mod download -x \
    && make lint.install \
    && rm -rf ../external-secrets 

RUN go install github.com/mikefarah/yq/v4@latest
RUN go install sigs.k8s.io/controller-runtime/tools/setup-envtest@latest

# Unit tests want these older versions
RUN go get github.com/aws/aws-sdk-go@v1.43.36 \
    github.com/Azure/go-autorest/autorest/adal@v0.9.18 \
    github.com/AzureAD/microsoft-authentication-library-for-go@v0.4.0 \
    golang.org/x/crypto@v0.0.0-20220214200702-86341886e292
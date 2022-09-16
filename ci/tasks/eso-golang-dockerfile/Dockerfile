FROM golang:1.19-bullseye

RUN cd external-secrets-repo-gomod \
    && make lint.install \
    && go mod tidy \
    && go install github.com/mikefarah/yq/v4@latestenv

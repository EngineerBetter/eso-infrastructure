FROM golang:1.17-bullseye

RUN cd external-secrets-repo-gomod \
    && go mod tidy \
    && go install github.com/mikefarah/yq/v4@latestenv

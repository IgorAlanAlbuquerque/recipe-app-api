FROM python:3.10-alpine
LABEL maintainer="Igor Alan Albuquerque de Sousa"

ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /temp/requirements.txt
COPY ./requirements.dev.txt /temp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

ARG DEV=false
RUN python -m venv /pyenv && \
    /pyenv/bin/pip install --upgrade pip && \
    apk add --no-cache postgresql-client && \
    apk add --no-cache --virtual .tmp-build-deps \
        build-base postgresql-dev musl-dev && \
    /pyenv/bin/pip install -r /temp/requirements.txt && \
    if [ "${DEV:-false}" = "true" ]; then \
        /pyenv/bin/pip install -r /temp/requirements.dev.txt; \
    fi && \
    rm -rf /temp && \
    apk del .tmp-build-deps && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

ENV PATH="/pyenv/bin:$PATH"

USER django-user
FROM python:3.11-slim AS builder

WORKDIR /app

COPY requirements.txt .

RUN python -m venv venv && \
    venv/bin/pip install --no-cache-dir -r requirements.txt

FROM python:3.11-slim AS runner

WORKDIR /app

COPY --from=builder /app/venv venv
COPY . .

COPY dao/ ./dao
COPY model/ ./model
COPY service/ ./service
COPY static/ ./static
COPY templates/ ./templates
COPY app.py .
COPY mongo.py .

EXPOSE 5000

ENV MONGO_IP="mongo"
ENV MONGO_PORT="27017"

CMD ["venv/bin/python", "app.py", "--host=0.0.0.0"]
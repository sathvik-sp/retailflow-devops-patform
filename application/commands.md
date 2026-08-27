# Docker & ACR Commands

## 1. Go to the application directory

```bash
cd application
```

## 2. Create and activate Python virtual environment

```bash
python3 -m venv .venv
source .venv/bin/activate
```

## 3. Install application dependencies

```bash
pip install -r requirements.txt
```

## 4. Run Flask application locally

```bash
python app.py
```

Test the endpoints from another terminal:

```bash
curl http://localhost:5000/
curl http://localhost:5000/health
```

Expected:

```text
{"message":"RetailFlow API is running"}
{"status":"healthy"}
```

---

# Docker

## 5. Build the Docker image

From the `application/` directory:

```bash
docker build -t retailflow-api:dev .
```

Check the image:

```bash
docker images
```

Or:

```bash
docker images | grep retailflow-api
```

## 6. Run the container locally

```bash
docker run -d --name retailflow_api -p 5000:5000 retailflow-api:dev
```

Check the running container:

```bash
docker ps
```

Test the application:

```bash
curl http://localhost:5000/
curl http://localhost:5000/health
```

## 7. Stop and remove the test container

```bash
docker stop retailflow_api
docker rm retailflow_api
```

---
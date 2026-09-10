FROM python:3.12-slim-trixie

WORKDIR /app

COPY requirements.txt .

RUN apt-get update \
    && apt-get upgrade -y \
    && rm -rf /var/lib/apt/lists/* \
    && pip install --no-cache-dir -r requirements.txt \
    && pip install --no-cache-dir --upgrade \
        setuptools>=78.1.1 \
        wheel>=0.46.2 \
        jaraco.context>=6.1.0

COPY app.py .

EXPOSE 5000

CMD ["python", "app.py"]
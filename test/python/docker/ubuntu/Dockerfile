FROM ubuntu:18.10

RUN apt-get update && apt-get install -y \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip3 install -r requirements.txt
COPY test.py .

ENTRYPOINT [ "python3", "test.py" ]
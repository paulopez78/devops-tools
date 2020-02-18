FROM python:alpine

COPY requirements.txt .
RUN pip install -r requirements.txt
COPY test.py .

ENTRYPOINT [ "python", "test.py" ]
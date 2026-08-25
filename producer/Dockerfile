FROM python:3.12-slim

WORKDIR /producer/code

COPY generator.py .
COPY main.py .
COPY requirements.txt .
COPY schema.py .

RUN pip install --upgrade pip
RUN pip install -r requirements.txt

CMD ["python", "main.py"]
FROM python:3.7-slim-bullseye

RUN apt-get update -y && \
  apt-get install --no-install-recommends -y -q \
  git libpq-dev python-dev awscli && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /producer/code

COPY generator.py .
COPY main.py .
COPY requirements.txt 
COPY schema.py .

RUN pip install --upgrade pip
RUN pip install -r requirements.txt

CMD ["python", "main.py"]
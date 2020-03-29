FROM python:3-slim-buster
ARG UID
ARG GID
ENV PYTHONUNBUFFERED=true
WORKDIR /usr/local/src
COPY requirements.txt ./
RUN addgroup --system --gid $GID python \
 && adduser --system --no-create-home --gid $GID --uid $UID python \
 && pip install --no-cache-dir -r requirements.txt
USER python:python
WORKDIR /home/python
CMD ["python3", "task.py"]

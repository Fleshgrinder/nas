FROM python:3-slim-buster
VOLUME /out
VOLUME /tmp
WORKDIR /usr/local/src
COPY requirements.txt task.py ./
RUN pip install --no-cache-dir -r requirements.txt
CMD ["python", "task.py"]

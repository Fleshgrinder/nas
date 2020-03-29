FROM python:3-slim-buster
ENV PYTHONUNBUFFERED=true
WORKDIR /usr/local/src
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
CMD ["python3", "task.py"]

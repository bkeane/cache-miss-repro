FROM python:alpine
ARG SOURCE_DATE_EPOCH
COPY requirements.txt requirements.txt  
RUN pip install --no-cache-dir -r requirements.txt
COPY main.py main.py
CMD ["python", "main.py"]

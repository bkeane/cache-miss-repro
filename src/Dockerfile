FROM python:alpine AS build
ARG SOURCE_DATE_EPOCH
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY main.py .

FROM build AS release
CMD ["python", "main.py"]

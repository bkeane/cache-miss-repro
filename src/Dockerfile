FROM python:alpine
ARG SOURCE_DATE_EPOCH
COPY --from=public.ecr.aws/awsguru/aws-lambda-adapter:0.8.4 /lambda-adapter /opt/extensions/lambda-adapter
ADD requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
WORKDIR /src
COPY main.py .
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
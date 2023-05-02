FROM python:3.12.0a7

ARG USER=user
ARG GROUP=$USER
ENV HOME=/home/$USER

RUN addgroup --system $GROUP && adduser --system --home $HOME --ingroup $GROUP $USER

ENV CRON_SCHEDULE="* * * * *" \
    LOG_FILE="/tmp/influxdb-export.log" \
    LOG_LEVEL="INFO"

# NZBGet Variables
ENV NZBGET_USERNAME="influxdb" \
    NZBGET_PASSWORD= \
    NZBGET_URL= \
    NZBGET_URL_SSL="http" \
    NZBGET_PORT="6789" \
    NZBGET_VALUES_TO_RETURN="RemainingSizeMB,ForcedSizeMB,DownloadedSizeMB,ArticleCacheMB,DownloadRate,ThreadCount,PostJobCount"

# InfluxDB Variables
ENV INFLUXDB_TOKEN= \
    INFLUXDB_ORG= \
    INFLUXDB_URL= \
    INFLUXDB_URL_SSL="http" \
    INFLUXDB_PORT="8086" \
    INFLUXDB_BUCKET=

WORKDIR $HOME

COPY --chown=$USER:$GROUP requirements.txt .
COPY --chown=$USER:$GROUP export.py .
COPY --chown=$USER:$GROUP logging.conf .

RUN chmod 400 requirements.txt logging.conf && \
    chmod 500 export.py

USER $USER

RUN pip install -r requirements.txt --no-cache-dir

ENTRYPOINT ["python3", "export.py"]
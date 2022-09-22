FROM python:3.10.7

ARG USER=user
ARG GROUP=$USER
ENV HOME=/home/$USER

RUN addgroup --system $GROUP && adduser --system --home $HOME --ingroup $GROUP $USER

ENV CRON_SCHEDULE="* * * * *"
ENV LOG_FILE="/tmp/influxdb-export.log"

# NZBGet Variables
ENV NZBGET_USERNAME="influxdb"
ENV NZBGET_PASSWORD=
ENV NZBGET_URL=
ENV NZBGET_URL_SSL="http"
ENV NZBGET_PORT="6789"
ENV NZBGET_VALUES_TO_RETURN="RemainingSizeMB,ForcedSizeMB,DownloadedSizeMB,ArticleCacheMB,DownloadRate,ThreadCount,PostJobCount"

# InfluxDB Variables
ENV INFLUXDB_TOKEN=
ENV INFLUXDB_ORG=
ENV INFLUXDB_URL=
ENV INFLUXDB_URL_SSL="http"
ENV INFLUXDB_PORT="8086"
ENV INFLUXDB_BUCKET=

WORKDIR $HOME

COPY --chown=$USER:$GROUP requirements.txt .
COPY --chown=$USER:$GROUP export.py .
# COPY --chown=$USER:$GROUP run.sh .

RUN chmod 400 requirements.txt && \
    chmod 500 export.py

USER $USER

RUN pip install -r requirements.txt --no-cache-dir

ENTRYPOINT ["python3", "export.py"]

FROM alpine:3.16.2

ARG USER=root
ARG GROUP=root

ENV HOME=/$USER
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

RUN apk update && apk add --no-cache \
  bash=5.1.16-r2 \
  py3-pip=22.1.1-r0 \
  python3=3.10.5-r0 

WORKDIR $HOME

COPY --chown=$USER:$GROUP requirements.txt .
COPY --chown=$USER:$GROUP export.py .
COPY --chown=$USER:$GROUP run.sh .

RUN chmod 400 requirements.txt && \
    chmod 500 run.sh export.py

RUN pip install -r requirements.txt --no-cache-dir

ENTRYPOINT ["sh", "run.sh"]
CMD ["start"]

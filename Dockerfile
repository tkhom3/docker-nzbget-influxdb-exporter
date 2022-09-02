FROM alpine:3.16.2

ENV USER=docker
ENV UID=12345
ENV GID=23456

WORKDIR /tmp

RUN adduser \
    --disabled-password \
    --home "$(pwd)" \
    --ingroup "$USER" \
    --no-create-home \
    --uid "$UID" \
    "$USER"

RUN apk update && apk add --no-cache \
  bash=5.1.16-r2 \
  py3-pip=22.1.1-r0 \
  python3=3.10.5-r0 

COPY run.sh .
COPY requirements.txt .
COPY export.py .

RUN ["chmod", "+x", "/run.sh"]

RUN pip3 install -r requirements.txt && \
    rm -rf /tmp/pip_build_root/

ENV CRON_SCHEDULE $CRON_SCHEDULE

# NZBGet Variables
ENV NZBGET_USERNAME $NZBGET_USERNAME
ENV NZBGET_PASSWORD $NZBGET_PASSWORD
ENV NZBGET_URL $NZBGET_URL
ENV NZBGET_URL_SSL $NZBGET_URL_SSL
ENV NZBGET_PORT $NZBGET_PORT
ENV NZBGET_VALUES_TO_RETURN $NZBGET_VALUES_TO_RETURN

# InfluxDB Variables
ENV INFLUXDB_TOKEN $INFLUXDB_TOKEN
ENV INFLUXDB_ORG $INFLUXDB_ORG
ENV INFLUXDB_URL $INFLUXDB_URL
ENV INFLUXDB_URL_SSL $INFLUXDB_URL_SSL
ENV INFLUXDB_PORT $INFLUXDB_PORT
ENV INFLUXDB_BUCKET $INFLUXDB_BUCKET

ENTRYPOINT ["/run.sh"]
CMD ["start"]

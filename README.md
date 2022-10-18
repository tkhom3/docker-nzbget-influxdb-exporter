[![Build and Deploy Image](https://github.com/tkhom3/docker-nzbget-influxdb-exporter/actions/workflows/build-and-deploy.yml/badge.svg)](https://github.com/tkhom3/docker-nzbget-influxdb-exporter/actions/workflows/build-and-deploy.yml)
[![Security Scans](https://github.com/tkhom3/docker-nzbget-influxdb-exporter/actions/workflows/security-scans-pr.yml/badge.svg)](https://github.com/tkhom3/docker-nzbget-influxdb-exporter/actions/workflows/security-scans-pr.yml)
[![Codacy Badge](https://app.codacy.com/project/badge/Grade/192a0a677e4e401db3b77d4725636b9f)](https://www.codacy.com/gh/tkhom3/docker-nzbget-influxdb-exporter/dashboard?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=tkhom3/docker-nzbget-influxdb-exporter&amp;utm_campaign=Badge_Grade)

# docker-nzbget-influxdb-exporter

Export NZBget metrics to InfluxDBv2 bucket.

## Environment Variables

### General

| **Variable**  | **Default** | **Description** |
|-|-|-|
| CRON_SCHEDULE | `* * * * *` | How often a backup should be run using CRON |
| LOG_FILE | `/tmp/influxdb-export.log` | Location to write the log file |

### NZBGet

| **Variable**  | **Default** | **Description** |
|-|-|-|
| NZBGET_URL | | URL for NZBGet |
| NZBGET_URL_SSL | `http` | `http\|https` |
| NZBGET_PORT | `6789` | NZBGet Port |
| NZBGET_USERNAME | `influxdb` | Username to access NZBGet API |
| NZBGET_PASSWORD | | Password to access NZBGet API |
| NZBGET_VALUES_TO_RETURN | `RemainingSizeMB,ForcedSizeMB,DownloadedSizeMB,ArticleCacheMB,DownloadRate,ThreadCount,PostJobCount` | Values to return |

### Influx DB

| **Variable**  | **Default** | **Description** |
|-|-|-|
| INFLUXDB_URL | | InfluxDB URL |
| INFLUXDB_URL_SSL | `http` | `http\|https` |
| INFLUXDB_PORT | `8086` | InfluxDB Port|
| INFLUXDB_TOKEN | | Token to access InfluxDB with write access to the bucket |
| INFLUXDB_ORG | | The Organization associated to the Bucket |
| INFLUXDB_BUCKET | | InfluxDB Bucket where metrics will be written |

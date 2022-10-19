"""Retrieve NZBGet metrics via API and send to InfluxDB version 2."""

import os
from os import path
import time
import logging
import logging.config
import requests
from influxdb_client import InfluxDBClient, Point
from influxdb_client.client.write_api import SYNCHRONOUS


class NZBGet:

    """Class for NZBGet."""
    def __init__(self) -> None:
        self.username = os.getenv('NZBGET_USERNAME')
        self.password = os.getenv('NZBGET_PASSWORD')
        self.url = os.getenv('NZBGET_URL')
        self.url_ssl = os.getenv('NZBGET_URL_SSL')
        self.port = os.getenv('NZBGET_PORT')
        self.values_to_return = os.getenv('NZBGET_VALUES_TO_RETURN').split(',')

    def get_nzb_status_metrics(self, api_endpoint):
        """ Retrieves metrics from NZBGet."""
        nzbget_endpoint = f'{self.url_ssl}://{self.username}:{self.password}@{self.url}:' \
                          f'{self.port}/jsonrpc/{api_endpoint}'
        response = requests.get(nzbget_endpoint, timeout=45)
        result = response.json().get('result')
        for key in [key for key in result if key not in self.values_to_return]:
            del result[key]
        return result


class InfluxDB:

    """Class for InfluxDB."""
    def __init__(self) -> None:
        self.token = os.getenv('INFLUXDB_TOKEN')
        self.org = os.getenv('INFLUXDB_ORG')
        self.url = os.getenv('INFLUXDB_URL')
        self.url_ssl = os.getenv('INFLUXDB_URL_SSL')
        self.port = os.getenv('INFLUXDB_PORT')
        self.bucket = os.getenv('INFLUXDB_BUCKET')

    def get_influxdb_client(self):
        """Gets an API client for InfluxDB."""
        return InfluxDBClient(
            url=f'{self.url_ssl}://{self.url}:{self.port}',
            token=self.token,
            org=self.org
        )

    def write_to_influxdb(self):
        """Writes metrics to InfluxDB."""
        client = self.get_influxdb_client()
        endpoint = 'status'
        write_api = client.write_api(write_options=SYNCHRONOUS, precision="s")

        metrics = NZBGet().get_nzb_status_metrics(endpoint)

        for key in metrics:
            key_point = Point(key).field(key, metrics[key])
            write_api.write(bucket=self.bucket, record=key_point)


def collect_metrics():
    """Calls write_to_influxdb."""
    return InfluxDB().write_to_influxdb()


if __name__ == '__main__':
    log_file_path = path.join(path.dirname(path.abspath(__file__)), 'logging.conf')
    logging.config.fileConfig(log_file_path)
    logger = logging.getLogger(__name__)
    level = logging.getLevelName(os.getenv('LOG_LEVEL'))
    logger.setLevel(level)

    STARTTIME = time.time()
    RUNNING = False
    while True:
        if not RUNNING:
            RUNNING = True
            try:
                logger.info('Collecting logs')
                collect_metrics()
                logger.warning('Collecting logs')
                logger.exception('Collecting logs')
                RUNNING = False
            except requests.exceptions.ConnectTimeout as error:
                logger.warning('Connection timed out: %s', error)
                RUNNING = False
            except requests.exceptions.ConnectionError as error:
                logger.warning('Could not connect to host: %s', error)
                RUNNING = False
            except requests.exceptions.InvalidURL as error:
                logger.exception('Check environment variables and ensure a valid host is being set.: %s', error)
                break
            except Exception as error:  # pylint: disable=broad-except
                logger.exception('ERROR: %s', error)
                break
        time.sleep(60.0 - ((time.time() - STARTTIME) % 60.0))

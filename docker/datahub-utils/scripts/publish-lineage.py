#!/usr/local/bin/python3
import json
import logging
import os
from argparse import ArgumentParser
from dataclasses import dataclass
from pathlib import Path
from typing import List, Optional

import datahub.emitter.mce_builder as builder
from datahub.emitter.rest_emitter import DataHubRestEmitter
from datahub.metadata.schema_classes import MetadataChangeEventClass


@dataclass
class LineageInformation:
    """
    Class represent a part of lineage information.
    A lineage should have 2 side: upstream and downstream. A part may have many upstreams, but only one downstream.
    """
    upstream_urns: List[str]
    downstream_urn: str

    # When user move mouse over class name, most IDE will show documentation of constructor.
    # So we also duplicate docs from constructor to here.
    def __init__(
        self,
        upstream_urns: List[str],
        downstream_urn: str
    ):
        """
        Class represent a part of lineage information.
        A lineage should have 2 side: upstream and downstream. A part may have many upstreams, but only one downstream.

        Args:
            upstream_urns: List of URN of upstream dataset,
            downstream_urn: URN of downstream dataset.
        """
        assert upstream_urns is not None
        assert downstream_urn is not None

        self.upstream_urns = upstream_urns
        self.downstream_urn = downstream_urn

    def to_mce_lineage(self) -> MetadataChangeEventClass:
        """
        Convert lineage information into MCE, so Datahub Rest Emitter can send it.
        For more information about MCE, see: https://datahubproject.io/docs/what/mxe/
        Returns:
            A MCE object contain lineage information.
        """
        return builder.make_lineage_mce(
            self.upstream_urns,
            self.downstream_urn
        )


def main(args):
    # Create emitter with information from environment variable.
    datahub_rest_emitter = create_datahub_rest_emitter_from_env()

    try:
        # Get lineage informations.
        lineage_informations = parse_lineage_informations(args.lineage_file, args.lineage_content_json)
        # Emit it to Datahub.
        send_lineage_informations_to_datahub(datahub_rest_emitter, lineage_informations)
    except RuntimeError:
        logging.error("No lineage to emit!")


def create_datahub_rest_emitter_from_env() -> DataHubRestEmitter:
    """
    Create DatahubRestEmitter with information from env:
    - DATAHUB_GMS_SERVER_ENDPOINT: Endpoint of Datahub GMS service. Default: http://localhost:8080.
    - DATAHUB_GMS_SERVER_TOKEN: Token required to access Datahub GMS service. Default: empty string.
    """

    DATAHUB_GMS_SERVER_ENDPOINT = "DATAHUB_GMS_SERVER_ENDPOINT"
    DATAHUB_GMS_SERVER_TOKEN = "DATAHUB_GMS_SERVER_TOKEN"

    check_env_availbility([
        DATAHUB_GMS_SERVER_ENDPOINT,
        DATAHUB_GMS_SERVER_TOKEN
    ])

    datahub_gms_server_endpoint = os.environ.get(DATAHUB_GMS_SERVER_ENDPOINT, "http://localhost:8080")
    datahub_gms_server_token = os.environ.get(DATAHUB_GMS_SERVER_TOKEN, "")

    datahub_gms_emitter = DataHubRestEmitter(
        gms_server=datahub_gms_server_endpoint,
        token=datahub_gms_server_token
    )

    datahub_gms_emitter.test_connection()

    return datahub_gms_emitter

def parse_lineage_informations(
    lineage_content_json: Optional[str],
    lineage_information_file_path: Optional[Path]
) -> List[LineageInformation]:
    """
    Get and parse lineage information from either file (`--lineage-informtion-file-path`)
    or direct param input (`lineage_content_json`).
    If both file param and JSON param existed, the JSON param will be prioritied.

    Args:
        lineage_content_json: str, Optional
            Lineage infomration in JSON string format.

        lineage_information_file_path: Path, Optional
            Path of the file contain lineage information.
    """

    lineage_information_list: List[LineageInformation]

    if lineage_content_json is not None:
        lineage_information_list = parse_lineage_informations_from_json_str(lineage_content_json)
    elif lineage_information_file_path is not None:
        lineage_information_list = parse_lineage_informations_from_file(lineage_information_file_path)
    else:
        raise RuntimeError("Either --lineage-information-file-path or --lineage-content-json is required.")

    return lineage_information_list

def parse_lineage_informations_from_json_str(lineage_content_json: str) -> List[LineageInformation]:
    """
    Read a JSON string and parse it content into a List of LineageInformation objects

    Args:
        lineage_content_json: str, required
            JSON string contain lineage informations.
    """

    return json.loads(lineage_content_json)

def parse_lineage_informations_from_file(lineage_information_file_path: Path) -> List[LineageInformation]:
    """
    Read a JSON file and parse it content into a List of LineageInformation objects

    Args:
        lineage_information_file_path: Path, required
            Path of file contain lineage informations.
    """

    with open(lineage_information_file_path, "r") as lineage_information_file:
        lineage_information: List[LineageInformation] = json.load(lineage_information_file)

    return lineage_information

def send_lineage_informations_to_datahub(emitter: DataHubRestEmitter, lineage_information_list: List[LineageInformation]):
    """
    Send a list of lineage informations to Datahub GMS service.

    Args:
        emitter: DatahubRestEmitter, required.
            An instance of DatahubRestEmitter.
        lineage_informations: List[LineageInformation], required.
            A list of lineage information to send to Datahub.
    """
    for lineage_information in lineage_information_list:
        emitter.emit_mce(lineage_information.to_mce_lineage())


def check_env_availbility(env_list: List[str]):
    """
    Check and warn if any env variable in the list is not set.

    Args:
        env_list: List[str], required
        A list of environment variables to check.
    """

    for env in env_list:
        if os.environ.get(env) is None:
                    logging.warning(
                "Variable {} is not set! It'll become None or default value if it exists.",
                env
            )


def parse_argument(*args):
    """
    Parse required argument before feeding it to the main method.

    ---

    Parameters
    ----------

    lineage_file: `pathlib.Path`, Optional
        Location of the file contain lineage information.

    lineage_content_json: `str`, Optional
        JSON string contains lineage information.
    """
    parser = ArgumentParser()

    parser.add_argument(
        "--lineage-file",
        dest="lineage_file",
        type=Path,
        required=False,
        help="Location of the file contain lineage information to publish to Datahub."
             "Example: /opt/lineage-information/lineage.json."
             "This arg will be ignored if --lineage-content-json is exists.",
    )

    parser.add_argument(
        "--lineage-content-json",
        dest="lineage_content_json",
        type=str,
        required=False,
        help="Content of the lineage information in JSON String."
    )

    return parser.parse_args(*args)


if __name__ == '__main__':
    main(args=parse_argument())

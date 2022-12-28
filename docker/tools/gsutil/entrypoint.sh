#!/bin/sh
set -eo pipefail

S3_SSL="True"
if [ "$S3_INSECURE" == "True" ]; then
    echo "WARNING: access S3 without TLS/SSL"
    S3_SSL="False"
fi

cat > $HOME/.boto << EOF
[Credentials]
s3_host = ${S3_HOST}
s3_port = ${S3_PORT}

aws_access_key_id = ${AWS_ACCESS_KEY_ID}
aws_secret_access_key = ${AWS_SECRET_ACCESS_KEY}

gs_access_key_id = ${GS_ACCESS_KEY_ID}
gs_secret_access_key = ${GS_SECRET_ACCESS_KEY}

[Boto]
is_secure = ${S3_SSL}

[s3]
# https://cloud.google.com/storage/docs/interoperability#invalid_certificate_from_bucket_names_containing_dots
calling_format = boto.s3.connection.OrdinaryCallingFormat
EOF

exec "$@"

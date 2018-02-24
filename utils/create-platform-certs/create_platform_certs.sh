#!/usr/bin/env bash
set -e

GIT_REPO_TOP_LEVEL="$(git rev-parse --show-toplevel)"

cd "${GIT_REPO_TOP_LEVEL}"/utils/create-platform-certs

COMBINED_CERT_FILE=./ca-bundle.crt
HASH_FILE=./SHA256SUMS
MK_CA_BUNDLE_PL_EXEC=./mk-ca-bundle.pl
SPLIT_CERT_DIR="${GIT_REPO_TOP_LEVEL}"/test/rules/platform_certs/default/
SPLIT_COMBINED_CERT_FILE_EXEC=./split_combined_cert_file.py

sha256sum -c "${HASH_FILE}"

git rm -r -f -q "${SPLIT_CERT_DIR}"

mkdir -p "${SPLIT_CERT_DIR}"

perl "${MK_CA_BUNDLE_PL_EXEC}" -n "${COMBINED_CERT_FILE}"

python "${SPLIT_COMBINED_CERT_FILE_EXEC}" "${COMBINED_CERT_FILE}" "${SPLIT_CERT_DIR}"

rm "${COMBINED_CERT_FILE}"

c_rehash "${SPLIT_CERT_DIR}"

git add "${SPLIT_CERT_DIR}"

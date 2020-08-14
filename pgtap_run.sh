#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail -o posix

# Default settings
export PGHOST="${PGHOST:-localhost}"
export PGPORT="${PGPORT:-5432}"
export PGUSER="${PGUSER:-postgres}"
export PGDATABASE="${PGDATABASE:-postgres}"
TESTS='/t/*.sql'

usage() {
cat << EOM

Usage: test [-h HOSTNAME] [-p PORT] [-U USERNAME] [-d DBNAME] [-t TESTS]

Run pgTap tests against a running PostgreSQL server.

Installs and uninstalls pgTap functions on the target server using pgTap's bundled SQL scripts, therefore you must provide a database user with administrative privileges to run this script.

Set the PGPASSWORD environment variable to provide a password.

Options:
  -h    HOSTNAME    PostgreSQL host to connect to. Defaults to the PGHOST environment variable, or 'localhost' in the absence of it.
  -p    PORT        PostgreSQL port to connect to. Defaults to the PGPORT environment variable.
  -U    USERNAME    PostgreSQL user to connect as. Defaults to the PGUSER environment variable, or 'postgres' in the absence of it.
  -d    DBNAME      PostgreSQL database to connect to. Defaults to the PGDATABASE environment variable, or 'postgres' in the absence of it.
  -t    TESTS       Test(s) to run. May be a single filename or a glob pattern. Defaults to 't/*.sql/'.

EOM
exit 64  # EX_USAGE
}

while getopts h:p:U:d:t: OPT
do
  case "${OPT}" in
    h)
      export PGHOST="${OPTARG}"
      ;;
    p)
      export PGPORT="${OPTARG}"
      ;;
    U)
      export PGUSER="${OPTARG}"
      ;;
    d)
      export PGDATABASE="${OPTARG}"
      ;;
    t)
      TESTS="${OPTARG}"
      ;;
    \?)
      usage
      ;;
  esac
done

# uninstall pgTap on script exit
uninstall_pgtap() {
  psql -f /uninstall_pgtap.sql >/dev/null 2>&1
}

trap uninstall_pgtap EXIT

# install pgTap
psql -f /pgtap.sql >/dev/null 2>&1

# run the tests
pg_prove ${TESTS}

FROM postgres

ENV PGTAP_VERSION=1.0.0

RUN apt-get update \
 && apt-get install -y libtap-parser-sourcehandler-pgtap-perl build-essential postgresql-server-dev-all wget \
 # Install pgTap from source (needed for the generated install/uninstall scripts)
 && wget "https://github.com/theory/pgtap/archive/v${PGTAP_VERSION}.tar.gz" \
 && tar -zxf "v${PGTAP_VERSION}.tar.gz" \
 && cd "pgtap-${PGTAP_VERSION}" \
 && make \
 && make install \
 && mv sql/pgtap.sql sql/uninstall_pgtap.sql / \
 && cd - \
 # Cleanup
 && rm -rf "v${PGTAP_VERSION}.tar.gz" \
 && rm -rf "pgtap-${PGTAP_VERSION}" \
 && rm -rf /root/.cpan \
 && apt-get remove -y build-essential postgresql-server-dev-all wget \
 && apt-get clean -y \
 && apt-get autoremove -y

COPY pgtap_run.sh /bin/pgtap_run

# Configure non-root user
RUN useradd --create-home app
WORKDIR /home/app
USER app

ENTRYPOINT ["pgtap_run"]

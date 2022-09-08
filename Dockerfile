ARG COCKROACH_IMAGE_TAG=v21.2.15

FROM cockroachdb/cockroach:$COCKROACH_IMAGE_TAG

RUN microdnf update -y \
    && microdnf install findutils -y \
    && rm -rf /var/cache/yum

WORKDIR /app

COPY ./authe-db/init/ ./init/
COPY ./authe-db/start.sh ./start.sh
RUN chmod +x ./start.sh

ENV AUTHE_DB_PORT=22000 \
    AUTHE_DB_ADMIN_PORT=22001 \
    AUTHE_DB_PASSWORD=password

EXPOSE 22000
EXPOSE 22001

ENTRYPOINT ["./start.sh"]
CMD []

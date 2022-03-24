ARG COCKROACH_IMAGE_TAG=v21.2.7

FROM cockroachdb/cockroach:$COCKROACH_IMAGE_TAG

WORKDIR /app

COPY ./authe-db/start.sh ./start.sh
RUN chmod +x ./start.sh

ENV AUTHE_DB_PORT=22000 \
    AUTHE_DB_ADMIN_PORT=22001

EXPOSE 22000
EXPOSE 22001

ENTRYPOINT ["./start.sh"]
CMD []

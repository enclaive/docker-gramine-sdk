FROM enclaive/debug-gramine

COPY debug-env/packages.txt .
RUN apt-get update && xargs -a packages.txt -r apt-get install -y

COPY debug-env/entrypoint.sh /

ENTRYPOINT [ "/entrypoint.sh" ]

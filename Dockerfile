FROM python

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential python3-dev python3-pip python3-setuptools \
        python3-wheel python3-cffi libcairo2 libpango-1.0-0 \
        libpangocairo-1.0-0 libgdk-pixbuf2.0-0 libffi-dev \
        shared-mime-info ttf-wqy-microhei ttf-wqy-zenhei \
        && pip install WeasyPrint \
        && pip install mkdocs mkdocs-pdf-export-plugin mkdocs-material \
        && mkdir /data && rm -rf /var/lib/apt/lists/*

WORKDIR /data

EXPOSE 80

VOLUME ["/data"]

RUN apt-get update && apt-get install -y --no-install-recommends socat

CMD ["python3"]
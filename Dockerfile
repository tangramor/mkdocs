FROM python

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential python3-dev python3-pip python3-setuptools \
        python3-wheel python3-cffi libcairo2 libpango-1.0-0 \
        libpangocairo-1.0-0 libgdk-pixbuf2.0-0 libffi-dev \
        shared-mime-info ttf-wqy-microhei ttf-wqy-zenhei socat \
        && pip install WeasyPrint \
        && pip install mkdocs mkdocs-pdf-export-plugin mkdocs-material \
        && pip install pygments pymdown-extensions \
        && mkdir ~/.fonts && cd ~/.fonts/ \
        && wget https://cdn.bootcss.com/material-design-icons/3.0.1/iconfont/MaterialIcons-Regular.ttf \
        && wget https://cdn.bootcss.com/material-design-icons/3.0.1/iconfont/MaterialIcons-Regular.woff \
        && wget https://cdn.bootcss.com/material-design-icons/3.0.1/iconfont/MaterialIcons-Regular.eot \
        && mkdir /data && rm -rf /var/lib/apt/lists/*

WORKDIR /data

EXPOSE 80

VOLUME ["/data"]

CMD ["python3"]

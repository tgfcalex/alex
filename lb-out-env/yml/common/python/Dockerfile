FROM python:3.7.1-alpine3.8

ARG APPUSER='appuser'
ENV PATH /script/:$PATH

COPY requirements.txt /tmp/
RUN set -ex && \
    pip install -r /tmp/requirements.txt && \
     adduser --disabled-password ${APPUSER}

WORKDIR /script/
USER ${APPUSER}

CMD [ "/script/main.py" ]

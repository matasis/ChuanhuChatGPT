FROM python:3.10-slim-buster as builder
RUN sed -i 's/http:\/\/deb.debian.org\/debian/http:\/\/mirrors.aliyun.com\/debian/' /etc/apt/sources.list
RUN apt-get update \
    && apt-get install -y build-essential \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
COPY requirements.txt .
COPY requirements_advanced.txt .
COPY pip.conf /root/.config/pip/pip.conf
RUN pip install --user --no-cache-dir -r requirements.txt --no-warn-script-location
# RUN pip install --user --no-cache-dir -r requirements_advanced.txt

FROM python:3.10-slim-buster
LABEL maintainer="iskoldt"
COPY --from=builder /root/.local /root/.local
ENV PATH=/root/.local/bin:$PATH
COPY . /app
WORKDIR /app
ENV dockerrun=yes
CMD ["python3", "-u", "ChuanhuChatbot.py","2>&1", "|", "tee", "/var/log/application.log"]
EXPOSE 7860

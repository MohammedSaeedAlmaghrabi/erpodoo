# استخدام Python 3.10 كقاعدة
FROM python:3.10-slim

# تحديث setuptools أولاً لتجنب مشكلة pkg_resources
RUN pip install --upgrade pip setuptools wheel

# تثبيت المتطلبات الأساسية للنظام
RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    libxml2-dev \
    libxslt1-dev \
    libldap2-dev \
    libsasl2-dev \
    libssl-dev \
    libjpeg-dev \
    zlib1g-dev \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# تثبيت lxml مع html_clean قبل أي تثبيت لمشروع Odoo
RUN pip install --no-cache-dir "lxml[html_clean]"

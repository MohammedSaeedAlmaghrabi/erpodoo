
# استخدام Python 3.10 كقاعدة
FROM python:3.10-slim

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
    wkhtmltopdf \
    && rm -rf /var/lib/apt/lists/*

# إنشاء مستخدم لـ Odoo
RUN useradd -m -d /home/odoo -u 1000 -U -r -s /bin/bash odoo

# نسخ ملف المتطلبات وتثبيت مكتبات Python
COPY requirements.txt /tmp/requirements.txt
RUN pip install --upgrade pip && \
    pip install wheel && \
    pip install -r /tmp/requirements.txt

# نسخ كود Odoo
COPY . /odoo
WORKDIR /odoo

# تغيير ملكية الملفات للمستخدم odoo
RUN chown -R odoo:odoo /odoo

# التبديل إلى المستخدم odoo
USER odoo

# المنفذ الافتراضي
EXPOSE 8069

# تشغيل Odoo
CMD ["python3", "odoo-bin", "--config=/odoo/odoo.conf"]

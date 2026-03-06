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

# إنشاء مستخدم لـ Odoo
RUN useradd -m -d /home/odoo -u 1000 -U -r -s /bin/bash odoo

# نسخ ملف المتطلبات
COPY requirements.txt /tmp/requirements.txt

# تثبيت المكتبات بشكل تدريجي لتجنب الأخطاء
RUN pip install --upgrade pip setuptools wheel && \
    pip install --no-cache-dir \
        asn1crypto==1.4.0 \
        Babel==2.9.1 \
        pytz \
        pillow \
        lxml \
        requests \
        werkzeug==2.0.2 \
        psycopg2-binary \
        && echo "تم تثبيت المكتبات الأساسية"

# محاولة تثبيت باقي المتطلبات إذا كانت موجودة
RUN if [ -f /tmp/requirements.txt ]; then \
    pip install --no-cache-dir -r /tmp/requirements.txt || true; \
    fi

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

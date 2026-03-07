FROM python:3.10-slim

# تحديث pip
RUN pip install --upgrade pip setuptools wheel

# تثبيت مكتبات النظام
RUN apt-get update && apt-get install -y \
    git build-essential \
    libxml2-dev libxslt1-dev \
    libldap2-dev libsasl2-dev \
    libssl-dev libjpeg-dev zlib1g-dev libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# إنشاء مستخدم odoo
RUN useradd -m -d /home/odoo -U -r -s /bin/bash odoo

# نسخ المشروع
COPY . /odoo
WORKDIR /odoo

# تثبيت متطلبات Odoo
RUN pip install --no-cache-dir -r requirements.txt

# تثبيت lxml مع html_clean
RUN pip install --no-cache-dir "lxml[html_clean]"

# صلاحيات
RUN chown -R odoo:odoo /odoo

USER odoo

EXPOSE 8069

CMD ["python3", "odoo-bin", "--config=/odoo/odoo.conf"]

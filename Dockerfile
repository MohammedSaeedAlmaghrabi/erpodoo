# استخدام Python 3.10 كقاعدة
FROM python:3.10-slim

# تحديث setuptools لتجنب مشاكل pkg_resources
RUN pip install --upgrade pip setuptools wheel

# تثبيت الأدوات الأساسية للنظام
RUN apt-get update && apt-get install -y \
    git build-essential \
    libxml2-dev libxslt1-dev \
    libldap2-dev libsasl2-dev \
    libssl-dev libjpeg-dev zlib1g-dev libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# تثبيت lxml مع html_clean
RUN pip install --no-cache-dir "lxml[html_clean]"

# إنشاء مستخدم Odoo
RUN useradd -m -d /home/odoo -U -r -s /bin/bash odoo

# نسخ مشروع Odoo وملف الإعدادات
COPY . /odoo
COPY odoo.conf /odoo/odoo.conf
WORKDIR /odoo

# تعديل صلاحيات الملفات
RUN chown -R odoo:odoo /odoo

# التبديل للمستخدم odoo
USER odoo

# فتح المنفذ الافتراضي
EXPOSE 8069

# تشغيل Odoo
CMD ["python3", "odoo-bin", "--config=/odoo/odoo.conf"]

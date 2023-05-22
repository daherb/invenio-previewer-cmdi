# -*- coding: utf-8 -*-
#
# Copyright (C) 2023 IDS Mannheim
#
# invenio-preview-cmid is free software; you can redistribute it and/or
# modify it under the terms of the MIT License; see LICENSE file for more
# details.

"""CMDI previewer."""
from flask import current_app, render_template, url_for
# from invenio_previewer.utils import detect_encoding
from lxml import etree
from io import StringIO
import requests

# Part implementing previewer
previewable_extensions = ['cmdi']
def can_preview(file):
    return file.filename.endswith('.cmdi')

def render(file):
    with file.open() as fp:
        encoding = "utf-8" # detect_encoding(fp, default="utf-8")
        content = fp.read().decode(encoding)
        transform = etree.XSLT(etree.fromstring(bytes(requests.get(url_for('static', filename='xsl/'+ current_app.config['CMDI_PREVIEWER_STYLESHEET'],_external=True)).text, "utf-8")))
        return str(transform(etree.fromstring(bytes(content, "utf-8"))))
    
def preview(file):
    return render(file)
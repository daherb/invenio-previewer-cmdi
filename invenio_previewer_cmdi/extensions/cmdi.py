# -*- coding: utf-8 -*-
#
# Copyright (C) 2023 IDS Mannheim
#
# invenio-preview-cmid is free software; you can redistribute it and/or
# modify it under the terms of the MIT License; see LICENSE file for more
# details.

"""CMDI previewer."""
from flask import current_app, render_template, url_for
# detect_encoding does not seem to be working here
# from invenio_previewer.utils import detect_encoding
from lxml import etree
import requests

# Part implementing previewer
previewable_extensions = ['cmdi']
def can_preview(file):
    return file.filename.endswith('.cmdi')

def render(file, stylesheet):
    with file.open() as fp:
        encoding = "utf-8" # detect_encoding(fp, default="utf-8")
        content = fp.read().decode(encoding)
        transform = etree.XSLT(etree.fromstring(bytes(stylesheet, "utf-8")))
        return str(transform(etree.fromstring(bytes(content, "utf-8"))))
    
def preview(file):
    current_app.logger.info('Rendering %s using stylesheet %s', file.filename, current_app.config['CMDI_PREVIEWER_STYLESHEET'])
    stylesheet = requests.get(url_for('static', filename='xsl/'+ current_app.config['CMDI_PREVIEWER_STYLESHEET'],_external=True)).text
    
    return render(file, stylesheet)

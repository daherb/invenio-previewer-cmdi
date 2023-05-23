# -*- coding: utf-8 -*-
#
# Copyright (C) 2023 IDS Mannheim
#
# invenio-previewer-cmdi is free software; you can redistribute it and/or
# modify it under the terms of the MIT License; see LICENSE file for more
# details.

"""Module tests."""

from flask import Flask

from invenio_previewer_cmdi import InvenioPreviewerCMDI
from invenio_previewer_cmdi.views import blueprint
from invenio_previewer_cmdi.extensions.cmdi import can_preview, render

import pkg_resources
import logging
def test_version():
    """Test version import."""
    from invenio_previewer_cmdi import __version__

    assert __version__


def test_init():
    """Test extension initialization."""
    app = Flask("testapp")
    assert "invenio-previewer-cmdi" not in app.extensions
    ext = InvenioPreviewerCMDI(app)
    assert "invenio-previewer-cmdi" in app.extensions
    app = Flask("testapp")
    assert "invenio-previewer-cmdi" not in app.extensions
    ext = InvenioPreviewerCMDI()
    ext.init_app(app)
    assert "invenio-previewer-cmdi" in app.extensions

def test_config(app):
    assert 'PREVIEWER_PREFERENCE' in app.config
    assert app.config['PREVIEWER_PREFERENCE'][-1] == 'invenio_previewer_cmdi'
    assert 'CMDI_PREVIEWER_STYLESHEET' in app.config
    assert app.config['CMDI_PREVIEWER_STYLESHEET'] == "simple.xsl"

def test_blueprint(app):
    assert "invenio_previewer_cmdi" not in app.blueprints
    app.register_blueprint(blueprint)
    assert "invenio_previewer_cmdi" in app.blueprints

class File(object):
    
    filename = "metadata.cmdi"

    def open(self):
        return open(pkg_resources.resource_filename('tests','resources/metadata.cmdi'),'rb')
    
def test_extension(app):
    file = File()
    assert can_preview(file)
    print()
    stylesheet = open(pkg_resources.resource_filename('invenio_previewer_cmdi','static/xsl/simple.xsl'), 'r').read()
    rendered = render(file, stylesheet)
    logging.getLogger().warn(rendered)
    assert "<html" in rendered
    assert "<h1>Wikipedia.de 2013 Diskussionen</h1>" in rendered

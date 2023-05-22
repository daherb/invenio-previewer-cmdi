# -*- coding: utf-8 -*-
#
# Copyright (C) 2023 IDS Mannheim
#
# invenio-preview-cmid is free software; you can redistribute it and/or
# modify it under the terms of the MIT License; see LICENSE file for more
# details.

"""invenio module for a CMDI previewer."""

from . import config
    
class InvenioPreviewerCMDI(object):
    """invenio-config-ids extension."""

    def __init__(self, app=None):
        """Extension initialization."""
        if app:
            self.init_app(app)

    def init_app(self, app):
        """Flask application initialization."""
        self.init_config(app)
        app.extensions["invenio-previewer-cmdi"] = self

    def init_config(self, app):
        """Initialize configuration."""
        for k in dir(config):
            app.config.setdefault(k, getattr(config, k))
        app.config['PREVIEWER_PREFERENCE'].append('invenio_previewer_cmdi') # .insert(0, 'invenio_previewer_cmdi')
                                   
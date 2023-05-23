# -*- coding: utf-8 -*-
#
# Copyright (C) 2023 IDS Mannheim
#
# invenio-previewer-cmdi is free software; you can redistribute it and/or
# modify it under the terms of the MIT License; see LICENSE file for more
# details.

"""invenio module for a CMDI previewer."""

from . import config
    
class InvenioPreviewerCMDI(object):
    """invenio-previewer-cmdi extension."""

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
        # Add previewer in the end of the list
        app.config.setdefault('PREVIEWER_PREFERENCE',[]).append('invenio_previewer_cmdi')
        # alternatively in the beginning
        # .insert(0, 'invenio_previewer_cmdi')
                                   

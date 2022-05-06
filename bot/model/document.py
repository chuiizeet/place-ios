from dataclasses import field
import os
from marshmallow import Schema, fields

class Document(Schema):
    x = fields.Integer(required=True)
    y = fields.Integer(required=True)
    hex = fields.String(required=True)
    upload = fields.Boolean(required=True)
    secret = fields.String(default='bot',missing='bot') # This is your bot secret, for demostration and fun stuff.

class Documents(Schema):
    documents = fields.List(fields.Nested(Document()))
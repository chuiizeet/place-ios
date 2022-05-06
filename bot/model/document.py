from marshmallow import Schema, fields

class Document(Schema):
    x = fields.Integer(required=True)
    y = fields.Integer(required=True)
    hex = fields.String(required=True)
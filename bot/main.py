from dotenv import load_dotenv
import os
from core.image_processing import SpriteProcessing

load_dotenv('.env')
from appwrite.client import Client

self_signed_status = True
    
client = Client()

(client
 .set_endpoint(os.environ.get('APPWRITE_ENDPOINT'))  # Your API Endpoint
 .set_project(os.environ.get('APPWRITE_PROJECT'))  # Your project ID
 .set_key(os.environ.get('APPWRITE_API_KEY'))  # Your secret API key
 # Use only on dev mode with a self-signed SSL cert
 .set_self_signed(status=self_signed_status)
 )

SpriteProcessing(path='./sprites/mario.png', client=client)
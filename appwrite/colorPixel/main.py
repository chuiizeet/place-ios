import json
from datetime import datetime
from appwrite.client import Client
from appwrite.query import Query
from appwrite.services.database import Database

def main(request, response):
	"""payload = 
	{		
		'hex': String,
		'x': Int,
		'y': Int,
		'secret': String <- for fun stuff 🥴        
	}
	Colors allowed: #000000,#1D2B53,#7E2553,#008751,#AB5236,#5F574F,#C2C3C7,#FFFFFF,#FF004D,#FFA300,#FFEC27,#00E436,#29ADFF,#83769C,#FF77A8,#FFCCAA
	"""

	payload = json.loads(request.payload or '{}')
	env = request.env

	"""Initialize the Appwrite client"""
	client = Client()
	client.set_endpoint(env["APPWRITE_ENDPOINT"]) 
	client.set_project(env["APPWRITE_FUNCTION_PROJECT_ID"]) # this is available by default.
	client.set_key(env["APPWRITE_API_KEY"]) 
	client.set_self_signed(status=True)
	is_bot = True if env['BOT_SECRET'] == payload.get("secret", "whatever") else False
	database = Database(client)		
	user_id = env['APPWRITE_FUNCTION_USER_ID']
	canvas_collection_id = env['CANVAS_COLLECTION_ID']
	pixels_placed_collection_id = env['PIXELS_PLACED_COLLECTION_ID']	
	delay_seconds = int(env['DELAY_SECONDS'])
	
	x = payload['x']
	y = payload['y']
	hex: str = payload['hex']
	hex = hex.upper()
	colors_allowed = env['COLORS_ALLOWED'].split(',')

	if hex not in colors_allowed or colors_allowed == None:
		return response.json({
		'success': False,
		'message': f"Invalid color {hex}: {colors_allowed}"
	})

	if payload == None:
		return response.json({
		'success': False,
		'message': "Invalid data"
	})

	if user_id == None:
		return response.json({
		'success': False,
		'message': "No userId"
	})	

	if x < 0 or x > 255 or y < 0 or y > 255:
		return response.json({
		'success': False,
		'message': "Invalid x or y location"
	})
	
	id = f"{x}_{y}"	
	time = int(datetime.now().timestamp())	# time in seconds

	# Verify if user is allowed to place a pixel
	queries = [
		Query.equal('userId', user_id),
		Query.greater('createdAt', time - delay_seconds)
	]
	if not is_bot:
		_pixels_placed = database.list_documents(
			collection_id=pixels_placed_collection_id,
			queries=queries,
			limit=1
		)['documents']
		

		if (len(_pixels_placed) > 0):
			return response.json({
			'success': False,
			'message': f"You can only place a pixel every {delay_seconds} seconds."
		})
	else:
		user_id = 'bot'
		print("FUNNY 😈")

	# Update or create
	try:
		database.update_document(
					collection_id=canvas_collection_id,
					document_id=id,
					data={
						'hex': hex,
						'userId': user_id,						
						'createdAt': time
					}
				)	
	except:
		database.create_document(
					collection_id=canvas_collection_id,
					document_id=id,
					data={
						'hex': hex,
						'userId': user_id,
						'x': x,
						'y': y,
						'createdAt': time
					}
				)		

	# Create a document in Pixels-Placed
	database.create_document(
		collection_id=pixels_placed_collection_id,
		document_id='unique()',
		data={
			'hex': hex,
			'userId': user_id,
			'x': x,
			'y': y,
			'createdAt': time
		}
	)

	return response.json({
		'success': True,		
	})
	
	
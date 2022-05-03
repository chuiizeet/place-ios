import json
from datetime import datetime
from appwrite.client import Client
from appwrite.query import Query
from appwrite.services.database import Database
from appwrite.services.storage import Storage

def main(request, response):
	"""Create a file with last pixels
	"""
	
	env = request.env

	"""Initialize the Appwrite client"""
	client = Client()
	client.set_endpoint(env["APPWRITE_ENDPOINT"]) 
	client.set_project(env["APPWRITE_FUNCTION_PROJECT_ID"]) # this is available by default.
	client.set_key(env["APPWRITE_API_KEY"])

	canvas_collection_id = '625e2e9586945e8bc82f' 	

	database = Database(client)		
	storage = Storage(client)

	# Get all documents
	documents = []	
	first_request = database.list_documents(
		collection_id=canvas_collection_id,		
		limit=1,
	)['documents']

	documents.extend(first_request)

	items = 1
	while items != 0:
		result = database.list_documents(
			collection_id=canvas_collection_id,
			cursor=documents[-1]['$id'],
			limit=100,			
		)

		if result['documents']:
			documents.extend(result['documents'])		
		items = len(result['documents'])			

	file_path = "out.json"
	time = int(datetime.now().timestamp())	# time in seconds

	# Create file
	with open(file_path, 'w') as outfile:
		json.dump({
			'createdAt': time,
			'docs': documents
		}, outfile)
	
	new_file = storage.create_file(
		bucket_id='pixels',
		file_id='unique()',
		file=file_path
	)

	files = storage.list_files(bucket_id='pixels')['files']	

	# Delete files
	for file in files:
		
		id = file['$id']
		if id != new_file['$id']:
			storage.delete_file(
				bucket_id='pixels',
				file_id=id
			)

	return response.json({
		'success': True,		
		'documents': f"{len(documents)}",
		'fileId': new_file['$id']
	})
	
	
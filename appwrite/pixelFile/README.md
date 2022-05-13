# pixelFile



## Documentation
This function create a json file with all pixels every hour for speed the client first load.

_CRON:_
`0 * * * *`

Recommend to set _time out_ at least `100`


_Example output:_

This function returns JSON response:

**Success**:

```json
{
    "documents":"3877",
    "fileId":"627dad9374d99325666a",
    "success":true
}
```

## Environment Variables

List of environment variables used by this cloud function:

- **APPWRITE_ENDPOINT** - Endpoint of Appwrite project
- **APPWRITE_API_KEY** - Appwrite API Key

## Deployment

### Using tar.gz
Manual deployment has no requirements and uses Appwrite Console to deploy the tag. First, enter the folder of your function. Then, create a tarball of the whole folder and gzip it. After creating .tar.gz file, visit Appwrite Console, click on the Deploy Tag button and switch to the Manual tab. There, set the entrypoint to src/mod.ts, and upload the file we just generated.
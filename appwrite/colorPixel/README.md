# colorPixel



## Documentation
The function is used to documents pixels into database in order for security and use bots.

Function supports bots, if you use a bot with the secret key then delay check is skipped.

The _hex_ should be a valid color.

_Example input:_

This function expects JSON input:

```json
{
    "x": 21,
    "y": 21,
    "hex": "#FFFFFF",
    "secret": "String <- for bot 🤖 (optional)"
}
```

_Example output:_

This function returns JSON response:

**Success**:

```json
{
    "success": true,    
}
```

**Failure**:

```json

{
    "success": false,
    "message": "You can only place a pixel every {delay_seconds} seconds."
}
```
**Note**: The message may be different depends in the input data for validate them.


## Environment Variables

List of environment variables used by this cloud function:

- **APPWRITE_ENDPOINT** - Endpoint of Appwrite project
- **APPWRITE_API_KEY** - Appwrite API Key
- **CANVAS_COLLECTION_ID** - Canvas collection Id
- **PIXELS_PLACED_COLLECTION_ID** - Pixels Placed collection Id
- **COLORS_ALLOWED** - Allowed colors separated by comma, for example `#000000,#1D2B53,#7E2553,#008751,#AB5236,#5F574F,#C2C3C7,#FFFFFF,#FF004D,#FFA300,#FFEC27,#00E436,#29ADFF,#83769C,#FF77A8,#FFCCAA`
- **DELAY_SECONDS** - Delay for a user between painting pixels, for example `30`
- **BOT_SECRET** - Bot secret keyword for skip delay, example `appwrite-bot`

## Deployment

### Using tar.gz
Manual deployment has no requirements and uses Appwrite Console to deploy the tag. First, enter the folder of your function. Then, create a tarball of the whole folder and gzip it. After creating .tar.gz file, visit Appwrite Console, click on the Deploy Tag button and switch to the Manual tab. There, set the entrypoint to src/mod.ts, and upload the file we just generated.
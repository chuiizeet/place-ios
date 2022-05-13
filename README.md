# Place iOS
![Appwrite](https://user-images.githubusercontent.com/63467479/164336754-ffffb848-85ec-4229-a24f-36b1e0c294ca.svg)

![Cover](https://raw.githubusercontent.com/chuiizeet/place-ios/master/images/cover.png)

Place iOS is r/place clone made with Appwrite and SwiftUI.  
I decide create this project for [Appwrite Hackathon](https://dev.to/devteam/announcing-the-appwrite-hackathon-on-dev-1oc0) to test me in SwiftUI and use majority appwrite Api's.

[My submission in dev.to](https://dev.to/chuiizeet/place-ios-rplace-canvas-clone-595a)

### Appwrite Setup

You can follow [Appwrite installation guide](https://appwrite.io/docs/installation).

1. Install [Appwrite CLI](https://appwrite.io/docs/command-line)
2. Login with `appwrite login`
3. Visit your Appwrite Console and create project with ID `625e2e5e9dd29a882d44`
4. Run initial setup with `appwrite deploy --all`
5. Create `pixels` storage and set bucket-level permissions to read=`role:all`.

Create the [colorPixel](https://github.com/chuiizeet/place-ios/tree/master/appwrite/colorPixel) and [pixelFile](https://github.com/chuiizeet/place-ios/tree/master/appwrite/pixelFile) functions.

### App Setup

Update [kconstants.swift](https://github.com/chuiizeet/place-ios/blob/master/reddit-place/Utils/kconstants.swift) file with your id's and api endpoint 

```swift
struct Appwrite {
    static let projectId = "[PROJECT_ID]"
    static let apiEndpoint = "[API_ENDPOINT]"
    
    static let canvasCollectionId = "[CANVAS_COLLECTION_ID]"
    static let pixelColorFunctionId = "[PIXEL_COLOR_FUNCTION_ID]"        
}
```
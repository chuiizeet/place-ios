//
//  CanvasViewModel.swift
//  reddit-place
//
//  Created by chuy g on 20/04/22.
//

import SwiftUI
import Appwrite

enum FetchError: Error {
    case empty
}

class CanvasViewModel: ObservableObject {
    
    @Published var documents: [Doc] = [Doc]()
    
    // MARK: - Properties
    /// The canvas properties hardcoded for test and demostration
    let canvasWidth: Int = 256
    let canvasHeight: Int = 256
    
    let canvasPixelFactor: Int = Int(UIScreen.main.scale) + 2
    
    /// Computed canvas size
    var canvasWidthComputed: CGFloat {
        return CGFloat(canvasWidth * canvasPixelFactor)
    }
    
    var canvasHeightComputed: CGFloat {
        return CGFloat(canvasWidth * canvasPixelFactor)
    }
    
    @Published var image: UIImage?
    @Published var pixelsArray: [Pixel] = [Pixel]()
    
    // MARK: - Helper Functions
    
    /// Fetch data from server
    /// 1- First fetch json file in storage
    /// 2- Fetch lost data in db
    func fetchPixels() async {
        let bucketId = "pixels"
        do {
            let result = try await AppwriteUtils.shared.storage.listFiles(bucketId: bucketId, search: nil, limit: 1, offset: nil, cursor: nil, cursorDirection: nil, orderType: nil)
            
            if result.files.isEmpty {
                throw FetchError.empty
            }
            
            let id = result.files[0].id
            
            Logger.debug(id, context: nil)
            
            // TODO: - Raise an error
//            let x = try await AppwriteUtils.shared.storage.getFileDownload(bucketId: "pixels", fileId: "6271c20295079e717848")

            let url = URL(string: "\(K.Appwrite.apiEndpoint)/storage/buckets/\(bucketId)/files/\(id)/download?project=\(K.Appwrite.projectId)" )
            
            let file = try await FileLoader().downloadFile(from: url!)
            
            DispatchQueue.main.async {
                self.documents = file.docs
            }
            // Get lost pixels
            
            let queries = [Query.greater("createdAt", value: file.createdAt)]
            
            // TODO: - Enhance this
            let dbResult = try await AppwriteUtils.shared.db.listDocuments(collectionId: K.Appwrite.canvasCollectionID, queries: queries, limit: 100, offset: nil, cursor: nil, cursorDirection: nil, orderAttributes: nil, orderTypes: nil)
            
            for doc in dbResult.documents {
                DispatchQueue.main.async {
                    self.documents.append(doc.convertTo(fromJson: Doc.from(map:)))
                }
            }
            
            // Sucess.. create image
            createImage { image, _ in
                if let image = image {
                    DispatchQueue.main.async {
                        self.image = image
                    }
                }
            }
            
        } catch {
            if let x = error as? Appwrite.AppwriteError {
                Logger.error(x.message, context: nil)
            } else {
                Logger.error(error.localizedDescription, context: nil)
            }
            // Show error message
        }
        
    }
    
    func computedCoords(location: CGPoint, hex: String, create: Bool = true) {
        let x = Int(ceil((location.x / CGFloat(canvasPixelFactor))))
        let y = Int(ceil((location.y / CGFloat(canvasPixelFactor))))
        Logger.debug("x:\(x) y: \(y)", context:nil)
        
        let startXPx = x > 0 ? Int((x-1) * canvasPixelFactor) : 1
        let endXPx = Int(x * canvasPixelFactor)
        
        let startYPx = y > 0 ? Int((y-1) * canvasPixelFactor) : 1
        let endYPx = Int(y * canvasPixelFactor)
        
        for i in startXPx..<endXPx{
            for j in startYPx..<endYPx{
                let offset: Int = (Int(canvasWidthComputed) * j) + i
                pixelsArray[offset] = Pixel(hexString: hex)
            }
        }
         
        // Recreate image
        if create {
            createImage { image, _ in
                if let image = image {
                    DispatchQueue.main.async {
                        self.image = image
                    }
                }
            }
        } else {
            Logger.debug("Whatever", context: nil)
        }
    }
    
    /// Create image
    private func createImage(completionHandler: @escaping (UIImage?, String?) -> Void){
        
        guard !documents.isEmpty else { fatalError() }
        
        guard canvasWidth > 0 && canvasHeight > 0 else { fatalError() }

        
        DispatchQueue.global(qos: .utility).async {
            let width = self.canvasWidth * self.canvasPixelFactor
            let height = self.canvasHeight * self.canvasPixelFactor
            let rgbColorSpace =     CGColorSpaceCreateDeviceRGB()
            let bitmapInfo =        CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue) // premultipliedLast or .none
            let bitsPerComponent =  8
            let bitsPerPixel =      32
                        
            var pixels = [Pixel]()
            
            if self.pixelsArray.isEmpty {
                
                for _ in 0..<width {
                    for _ in 0..<height {
                        pixels.append(Pixel(r: 255, g: 255, b: 255, a: 255))
                    }
                }
                
                // Colorize
                for doc in self.documents {
                    let x = doc.x + 1
                    let y = doc.y + 1
                    
                    let startXPx = x > 0 ? Int((x-1) * self.canvasPixelFactor) : 1
                    let endXPx = Int(x * self.canvasPixelFactor)
                    
                    let startYPx = y > 0 ? Int((y-1) * self.canvasPixelFactor) : 1
                    let endYPx = Int(y * self.canvasPixelFactor)
                    
                    for i in startXPx..<endXPx{
                        for j in startYPx..<endYPx{
                            let offset: Int = (Int(self.canvasWidthComputed) * j) + i
                            pixels[offset] = Pixel(hexString: doc.hex)
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    self.pixelsArray = pixels
                }
            } else {
                pixels = self.pixelsArray
            }
            
            Logger.debug("Total pixels: \(pixels.count)", context: pixels.count)
            guard let providerRef = CGDataProvider(data: NSData(bytes: &pixels,
                                    length: pixels.count * MemoryLayout<Pixel>.size)
                )
                else { return completionHandler(nil, "Error weird") }
                            
            guard let cgim = CGImage(
                width: width,
                height: height,
                bitsPerComponent: bitsPerComponent,
                bitsPerPixel: bitsPerPixel,
                bytesPerRow: width * MemoryLayout<Pixel>.size,
                space: rgbColorSpace,
                bitmapInfo: bitmapInfo,
                provider: providerRef,
                decode: nil,
                shouldInterpolate: true,
                intent: .absoluteColorimetric
                )
                else { return completionHandler(nil, "Error weird") }
//            let image = UIImage(cgImage: cgim, scale: UIScreen.main.scale, orientation: .up)
            completionHandler(UIImage(cgImage: cgim), nil)
        }
    }
    
//    /// Get the pixel index from user Touch location
//    func setNewPixelFromLocation(_ location: CGPoint) {
//        
//        let x: Int = Int(location.x)
//        let y: Int = Int(location.y)
//        guard let image = image else {
//            Logger.error("Image has not been processed yet")
//            return
//        }
//
//        let pixelData = image.cgImage!.dataProvider!.data
//        let _: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
//        
//        let canvasWidthNormalize: Int = canvasWidth * canvasPixelFactor
//
//        let pixelIndex: Int = ((canvasWidthNormalize * y) + x)
//        
////        changeImage(pixel: pixelIndex)
//    }

}

struct FileLoader {
    var session = URLSession.shared

    func downloadFile(from url: URL) async throws -> Pixelfile {
        let (data, _) = try await session.data(from: url)
        let decoder = JSONDecoder()
        return try decoder.decode(Pixelfile.self, from: data)
    }
}

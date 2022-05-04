//
//  PixelFile.swift
//  reddit-place
//
//  Created by chuy g on 03/05/22.
//

import Foundation

// MARK: - Pixelfile
struct Pixelfile: Codable {
    let createdAt: Int
    let docs: [Doc]
}

// MARK: - Doc
struct Doc: Codable {
    var hex, userID: String
    var x, y: Int
    var id: String
    var createdAt: Int? // Doesn't required

    enum CodingKeys: String, CodingKey {
        case hex
        case userID = "userId"
        case x, y, createdAt
        case id = "$id"
    }
    
    public static func from(map: [String: Any]) -> Doc {
                return Doc(
                    hex: map["hex"] as! String,
                    userID: map["userId"] as! String,
                    x: map["x"] as! Int,
                    y: map["y"] as! Int,
                    id: map[CodingKeys.id.stringValue] as! String,
                    createdAt: map["createdAt"] as? Int
                )
        }
    
    func contains(x: Int, y: Int) -> Bool {
        return self.x == x && self.y == y
    }
}

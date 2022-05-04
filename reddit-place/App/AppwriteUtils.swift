//
//  AppwriteUtils.swift
//  reddit-place
//
//  Created by chuy g on 18/04/22.
//


import SwiftyBeaver
import Appwrite

class AppwriteUtils {
    
    // Properties
    private let log = SwiftyBeaver.self
    static let shared = AppwriteUtils()

    private let client: Client
    let account: Account
    let db: Database
    let functions: Functions
    let storage: Storage
    
    // MARK: - Init
    
    init() {
        client = Client()
            .setProject(K.Appwrite.projectId)
            .setEndpoint(K.Appwrite.apiEndpoint)
        account = Account(client)
        db = Database(client)
        functions = Functions(client)
        storage = Storage(client)
    }
}

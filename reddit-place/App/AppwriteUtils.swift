//
//  AppwriteUtils.swift
//  reddit-place
//
//  Created by chuy g on 18/04/22.
//

import Appwrite

class AppwriteUtils {

    static let shared = AppwriteUtils()

    private let client: Client
    let account: Account
    let db: Database
    let functions: Functions
    let storage: Storage
    let realtime: Realtime
    
    // MARK: - Init
    
    init() {
        client = Client()
            .setProject(K.Appwrite.projectId)
            .setEndpoint(K.Appwrite.apiEndpoint)
            .setSelfSigned(true)
        account = Account(client)
        db = Database(client)
        functions = Functions(client)
        storage = Storage(client)
        realtime = Realtime(client)        
    }
}

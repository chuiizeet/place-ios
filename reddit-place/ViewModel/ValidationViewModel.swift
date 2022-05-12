//
//  ValidationViewModel.swift
//  reddit-place
//
//  Created by chuy g on 25/04/22.
//

import Foundation
import Appwrite

enum User {
    case guest
    case member
}

enum SignUpStatus {
    case idle
    case success
    case error
}

class ValidationViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var nickname: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    
    @Published var user: User = .guest
    
    var currrentEmail = ""
    
    // MARK: - Helper Functions
    
    /// Try to create user
    func signIn() async -> Bool {
        // Loading....
        do {
            let result = try await AppwriteUtils.shared.account.createSession(email: email, password: password)
            Logger.debug(result.toMap(), context: result)
            // Sucesss
            DispatchQueue.main.async {
                self.user = .member
                self.currrentEmail = self.email.lowercased()
            }
            
            return true
        }
        catch {
            
            if let err = error as? AppwriteError {
                Logger.error(err.message, context: nil)
            }
            
            // Error
            Logger.error(error.localizedDescription, context: nil)
        }
        
        return false
    }
    
    /// Try to create user
    func signUp() async throws -> SignUpStatus {
        
        var signUpStatus = SignUpStatus.idle
        
        do {
            let result = try await AppwriteUtils.shared.account.create(userId: "unique()", email: email, password: password, name: nickname)
            Logger.debug(result.toMap(), context: result)
            
            // Sucesss
            signUpStatus = .success
            
        }
        catch let error as Appwrite.AppwriteError {
            Logger.warning(error.localizedDescription, context: error)
        }
        catch {
            // Error
            Logger.error("Error: \(error)", context: error)
        }
        return signUpStatus
    }
    
    func logOut() async {
        do {
            // MARK: - TODO: Maybe an error?
            /// The sessions are deleted successfully but throws an error.
            /// Exception: The data couldn’t be read because it isn’t in the correct format.
            let _ = try await AppwriteUtils.shared.account.deleteSessions()
            DispatchQueue.main.async {
                self.user = .guest
            }
            
        } catch {
            if let err = error as? Appwrite.AppwriteError {
                Logger.warning("\(err.message) - \(String(describing: err.code))", context: nil)
            } else {
                Logger.error(error.localizedDescription, context: nil)
            }
            
            DispatchQueue.main.async {
                self.user = .guest
            }
        }
        
    }
    
    /// Verify is an user is currently 
    func verifyUser() async {
        do {
            let result = try await AppwriteUtils.shared.account.get()
            Logger.debug(result.toMap(), context: result)
            DispatchQueue.main.async {
                self.user = .member
                self.currrentEmail = result.email.lowercased()
            }
            
        }
        catch let error as Appwrite.AppwriteError {
            Logger.warning(error.localizedDescription, context: error)
        }
        catch {
            // Error
            Logger.error("Some error: \(error.localizedDescription)", context: error)
        }
    }
    
    func getSessions() async {
        do {
            /// https://github.com/appwrite/sdk-for-apple/issues/14
            // TODO: - Report this
            let result = try await AppwriteUtils.shared.account.getSessions()
            Logger.debug(result.toMap(), context: result)
            DispatchQueue.main.async {
                self.user = .member
            }
        } catch {
            if let err = error as? AppwriteError {
                Logger.error("\(err.message) - \(String(describing: err.code))", context: error)
            } else {
                Logger.error(error.localizedDescription, context: nil)
            }            
        }
    }
    
    // MARK: - Validation
    
    func isNicknameLength() -> Bool {
        return nickname.count >= 4
    }
    
    func isPasswordLength() -> Bool {
        return password.count >= 8
    }
    
    /// https://regexlib.com/
    func isEmailValid() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func isLoginComplete() -> Bool {
        return isPasswordLength() && isEmailValid()
    }
    
    func isSignUpComplete() -> Bool {
        let validation = isPasswordLength() && isEmailValid()
        if validation == false {
         return validation
        }
        // Random username for privacy and bla bla bla
        if !isNicknameLength() {
            nickname = randomString(length: 16)
        }
        
        return validation
    }
    
    private func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }

}

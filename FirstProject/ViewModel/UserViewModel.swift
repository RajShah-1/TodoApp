//
//  UserViewModel.swift
//  FirstProject
//
//  Created by Raj Shah on 1/28/25.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn
import GoogleSignInSwift
import UIKit

class UserViewModel: ObservableObject {
    @Published var userID: GIDGoogleUser? = nil

    func signIn() {
        guard let presentingViewController = (UIApplication.shared.connectedScenes.first
                as? UIWindowScene)?.windows.first?.rootViewController else { return }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { signInResult, error in
            if let error = error {
                print("Error during sign-in: \(error.localizedDescription)")
                return
            }
            
            guard let result = signInResult else {
                print("No result from Google Sign-In")
                return
            }
            
            // Successfully signed in, update userID
            self.userID = result.user
        }
    }

    func signOut() {
        GIDSignIn.sharedInstance.signOut()
        userID = nil
    }
}

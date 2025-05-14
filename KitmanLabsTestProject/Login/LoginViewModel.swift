//
//  LoginViewModel.swift
//  Kitman Labs Test Project
//
//  Created by Robert Mccahill on 13/05/2025.
//

import Foundation

@Observable
@MainActor
class LoginViewModel {
    let loginService: LoginService
    let onLoginSuccess: (String) -> Void
    
    init(loginService: LoginService, onLoginSuccess: @escaping (String) -> Void = { _ in }) {
        self.loginService = loginService
        self.onLoginSuccess = onLoginSuccess
    }
    
    var username: String = ""
    var password: String = ""
    
    private(set) var usernameErrorMessage: String? = nil
    private(set) var passwordErrorMessage: String? = nil
    
    private(set) var isLoggingIn: Bool = false
    private(set) var loginErrorMessage: String? = nil
    var showErrorMessage = false
    
    @MainActor
    func logIn() async {
        //prevent repeated taps triggering multiple login attempts
        guard isLoggingIn == false else { return }
        
        //local validation for username and password before sending values to server
        if username.count >= 3 {
            usernameErrorMessage = nil
        } else {
            usernameErrorMessage = "Must be at least 3 characters"
        }
        
        if password.count >= 3 {
            passwordErrorMessage = nil
        } else {
            passwordErrorMessage = "Must be at least 3 characters"
        }
        
        guard usernameErrorMessage == nil && passwordErrorMessage == nil else {
            return
        }
        
        //values are valid, indicate to the view that loading is in progress and call the login service
        isLoggingIn = true
        defer { isLoggingIn = false }
        
        do {
            try await loginService.logIn(username: username, password: password)
            self.onLoginSuccess(username)
        } catch {
            //
            loginErrorMessage = "An error occurred - Please try again."
            showErrorMessage = true
        }
    }
}

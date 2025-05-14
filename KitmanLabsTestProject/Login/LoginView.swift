//
//  ContentView.swift
//  Kitman Labs Test Project
//
//  Created by Robert Mccahill on 13/05/2025.
//

import SwiftUI

struct LoginView: View {
    @State var viewModel: LoginViewModel
    let showProgress = true
    
    var body: some View {
        ZStack {
            VStack(spacing: 48) {
                Text("Welcome")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                VStack(spacing: 24) {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Username")
                            Spacer()
                        }
                        TextField("", text: $viewModel.username)
                            .textFieldStyle(.roundedBorder)
                        if let usernameErrorMessage = viewModel.usernameErrorMessage {
                            Text(usernameErrorMessage)
                                .font(.callout)
                                .foregroundStyle(.red)
                        }
                        
                    }
                    .padding(.horizontal, 8.0)
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Password")
                            Spacer()
                        }
                        SecureField("", text: $viewModel.password)
                            .textFieldStyle(.roundedBorder)
                        if let passwordErrorMessage = viewModel.passwordErrorMessage {
                            Text(passwordErrorMessage)
                                .font(.callout)
                                .foregroundStyle(.red)
                        }
                    }
                    .padding(.horizontal, 8.0)
                }
                Button(action: {
                    Task {
                        await viewModel.logIn()
                    }
                }, label: {
                    Text("Log In")
                        .frame(minWidth: 168, minHeight: 24)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                })
                .buttonStyle(.borderedProminent)
                .alert(isPresented: $viewModel.showErrorMessage) {
                    Alert(
                        title: Text("Error"),
                        message: Text(viewModel.loginErrorMessage ?? "Something went wrong"),
                        dismissButton: .default(Text("Ok"))
                    )
                }
            }
            .frame(maxWidth: 640)
            .padding()
            if viewModel.isLoggingIn {
                ZStack {
                    Color.black.opacity(0.5).ignoresSafeArea()
                    ProgressView(label: {
                        Text("Logging in...")
                            .foregroundStyle(.white)
                    })
                    .tint(.white)
                    .padding(16)
                    .background(.black)
                    .cornerRadius(10.0)
                }
            }
        }
    }
}


fileprivate class PreviewLoginService: LoginService {
    let throwError: Bool
    let delay: ContinuousClock.Instant.Duration?
    
    init(throwError: Bool = false, delay: ContinuousClock.Instant.Duration? = nil) {
        self.throwError = throwError
        self.delay = delay
    }
    
    func logIn(username: String, password: String) async throws -> Void {
        if let delay = delay {
            try? await Task.sleep(for: delay)
        }
        
        if throwError {
            throw NSError()
        } else {
            return
        }
    }
}

#Preview {
    LoginView(viewModel: LoginViewModel(loginService: PreviewLoginService()))
}

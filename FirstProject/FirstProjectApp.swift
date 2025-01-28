import SwiftUI
import FirebaseCore
import GoogleSignIn
import GoogleSignInSwift
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        guard let clientID = FirebaseApp.app()?.options.clientID else { return false }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        return true
    }
    
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any] = [:]
    ) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}

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

@main
struct FirstProjectApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject private var userViewModel = UserViewModel()
    @StateObject private var listViewModel = ListViewModel()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(userViewModel)
                .environmentObject(listViewModel)
        }
    }
}

struct MainView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var listViewModel: ListViewModel

    var body: some View {
        NavigationView {
            VStack {
                if let userID = userViewModel.userID?.profile?.name {
                    ListView()
                    Spacer()
                    Text("Welcome, \(userID) 👋")
                    Button("Sign Out") {
                        userViewModel.signOut()
                    }
                } else {
                    Text("Sign in to continue")
                    GoogleSignInButton(action: userViewModel.signIn)
                        .frame(width: 200, height: 50)
                }
            }
        }
    }
}

//
//  AppDelegate.swift
//  MediaFinder
//
//  Created by Karim Mohamed on 29/11/2022.
//

import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    //MARK: - Propreties.
    var window: UIWindow?
    
    //MARK: - Application Methods
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        handleRoot()
        return true
    }
    
    //MARK: - Public Methods
    public func switchToSignInScreen(){
        let signInVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignInVC")
        let navController = UINavigationController(rootViewController: signInVC)
        window?.rootViewController = navController
    }
}

//MARK: - Private Methods
extension AppDelegate {
    private func handleRoot() {
        if UserDefaults.standard.data(forKey: "User") != nil {
            let isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
            if isLoggedIn {
                switchToHomeScreen()
            }else {
                switchToSignInScreen()
            }
        }
    }
    private func switchToHomeScreen(){
        let mediaListVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MediaListVC")
        let navController = UINavigationController(rootViewController: mediaListVC)
        window?.rootViewController = navController
    }
}

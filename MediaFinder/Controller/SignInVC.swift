//
//  SignInVC.swift
//  MediaFinder
//
//  Created by Karim Mohamed on 06/12/2022.
//

import UIKit

class SignInVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - Variables & properties
    private var user: User!
    
    // MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Sign In"
        self.user = getUserDataFromUserDefaults()
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
    }
    
    // MARK: - Actions
    @IBAction func signInBtn(_ sender: UIButton) {
        checkEnteredData()
    }
}

// MARK: - Private Methods
extension SignInVC {
    private func checkEnteredData() {
        guard  let enteredEmail = emailTextField.text, enteredEmail != "" ,
               let enteredPassword = passwordTextField.text, enteredPassword != ""
        else {
            showAlert(title: "Sorry", message: "Data is missing")
            return
        }
        if user.email == enteredEmail && user.password == enteredPassword {
            goToHomePage()
        } else {
            showAlert(title: "Sorry", message: "email or password wrong")
        }
    }
//    private  func goToMyProfile() {
//        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
    private func goToHomePage() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MediaListVC") as! MediaListVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    private func getUserDataFromUserDefaults() -> User?{
        if let userData = UserDefaults.standard.data(forKey: "User") {
            do {
                let userObject = try JSONDecoder().decode(User.self, from: userData)
                return userObject
            }
            catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}

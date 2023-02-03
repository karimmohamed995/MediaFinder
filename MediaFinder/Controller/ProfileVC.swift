//
//  ProfileVC.swift
//  MediaFinder
//
//  Created by Karim Mohamed on 08/12/2022.
//

import UIKit

class ProfileVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var userImageView: UIImageView!
    // MARK: - Variables & properties
    private  var user: User!
    
    // MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Profile"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .done, target: self, action:  #selector(logOutUser) )
        self.user = getUserDataFromUserDefaults()
        setup()
//        UserDefaults.standard.set(true, forKey: "isLoggedIn")
    }
//    override func viewWillAppear(_ animated: Bool) {
//        self.navigationItem.setHidesBackButton(true, animated: true)
//    }
}

// MARK: - Private Methods
extension ProfileVC {
    private func setup() {
        nameLabel.text = user.name
        emailLabel.text = user.email
        phoneLabel.text = user.phone
        addressLabel.text = user.address
        userImageView.image = user.userImage.getImage()
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
    @objc private func logOutUser(sender: AnyObject){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        appDelegate.switchToSignInScreen()
    }
}

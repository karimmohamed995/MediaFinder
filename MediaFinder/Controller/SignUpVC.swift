//
//  SignUpVC.swift
//  MediaFinder
//
//  Created by Karim Mohamed on 29/11/2022.
//

import SDWebImage
import SQLite

class SignUpVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var userImageView: UIImageView!
    
    // MARK: - Properties
    private let format = "SELF MATCHES %@"
    private let imagePicker = UIImagePickerController()
    private var user: User!
    
    private let userTable = Table("users")
    // Coloums
    private let id = Expression<Int>("id")
    private let name = Expression<String>("name")
    private let email = Expression<String>("email")
    private let phone = Expression<String>("phone")
    private let password = Expression<String>("password")
    private let address = Expression<String>("address")
    
    private var database: Connection!
    
    // MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        userImageView.sd_setImage(with: URL(string: "https://cdn.pixabay.com/photo/2015/10/01/17/17/car-967387_1280.png"), placeholderImage: UIImage(named: "360_F_229758328_7x8jwCwjtBMmC6rgFzLFhZoEpLobB6L8"))
        setupUI()
        setupConnection()
        
    }
    
    // MARK: - Actions
    
    @IBAction func userImageBtnTapped(_ sender: UIButton) {
      imageActionTapped()

    }
    @IBAction func addressBtnTapped(_ sender: UIButton) {
        goToMapVC()
    }
    @IBAction func signUpBtnTapped(_ sender: UIButton) {
        goToSignIn()
    }
    @IBAction func alreadyHaveAccTapped(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - SendAddress
extension SignUpVC: SendAddress {
    func sendAddress(address: String) {
        addressTextField.text = address
    }
}

extension SignUpVC: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            userImageView.image = pickedImage
        }
        dismiss(animated: true)
    }
}

// MARK: - Private Methods
extension SignUpVC {
    private func setupUI(){
        userImageView.image = UIImage(named:"360_F_229758328_7x8jwCwjtBMmC6rgFzLFhZoEpLobB6L8")
        self.title = "Sign Up"
    }
    private func imageActionTapped() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    private func setupConnection(){
        do{
            let docDir = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            
            let fileUrl = docDir.appendingPathComponent("users").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
            
        }catch {
            print(error.localizedDescription)
        }
    }
    private func setUserDataToUserDefaults(user:User){
        do {
            let userData = try JSONEncoder().encode(user) // convert From objevct to data
            UserDefaults.standard.set(userData, forKey: "User")
            
        }catch {
            print(error.localizedDescription)
        }
    }
    private func goToSignIn() {
        if isEnteredData() {
            if isValidRegex() {
                saveDataToUserDefaults()
                insertUser()
                moveToSignInVC()
            }
        }
    }
    private func goToMapVC() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapVC") as! MapVC
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //MARK: - insert user in SQLITE
    private func insertUser() {
        guard let name = nameTextField.text,
              let email = emailTextField.text,
              let phone = phoneTextField.text,
              let password = passwordTextField.text,
              let address = addressTextField.text
        else{
            return
        }
        let insertUser = self.userTable.insert(self.name <- name, self.email <- email, self.phone <- phone, self.password <- password, self.address <- address)
            do {
                try self.database.run(insertUser)
            }catch {
                print(error.localizedDescription)
            }
    }
    // MARK: - Regex.
    private func isValidEmail(email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let pred = NSPredicate(format: format, regex)
        return pred.evaluate(with: email)
    }
    private func isValidPassword(password: String) -> Bool {
        let regex = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{8,}$"
        let pred = NSPredicate(format: format, regex)
        return pred.evaluate(with: password)
    }
    private func isValidPhone(phone: String) -> Bool {
        let regex = "^[0-9]{11}$"
        let pred = NSPredicate(format: format, regex)
        return pred.evaluate(with: phone)
    }
    private func isValidRegex() -> Bool{
        guard isValidEmail(email: emailTextField.text!) else {
            self.showAlert(title: "sorry", message: "please enter valid email")
            return false
        }
        guard isValidPassword(password: passwordTextField.text!) else {
            self.showAlert(title: "sorry", message: "please enter valid password")
            
            return false
        }
        guard isValidPhone(phone: phoneTextField.text!) else {
            self.showAlert(title: "sorry", message: "please enter valid phone Number")
            return false
        }
        return true
    }
    private func isEnteredData () -> Bool {
        guard userImageView.image != UIImage(named: "360_F_229758328_7x8jwCwjtBMmC6rgFzLFhZoEpLobB6L8") else {
            self.showAlert(title: "sorry", message: "please choose image")
            return false
        }
        guard nameTextField.text != "" else {
            self.showAlert(title: "sorry", message: "please enter name")
            return false
        }
        guard emailTextField.text != "" else {
            self.showAlert(title: "sorry", message: "please enter email")
            return false
        }
        guard phoneTextField.text != "" else {
            self.showAlert(title: "sorry", message: "please enter phone")
            return false
        }
        guard passwordTextField.text != "" else {
            self.showAlert(title: "sorry", message: "please enter password")
            return false
        }
        guard addressTextField.text != "" else {
            self.showAlert(title: "sorry", message: "please enter address")
            return false
        }
        return true
    }
    private func moveToSignInVC() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    private func saveDataToUserDefaults(){
        let user = User(name: nameTextField.text, email: emailTextField.text, phone: phoneTextField.text, password: passwordTextField.text, address: addressTextField.text, userImage: CodableImage(withImage: userImageView.image!))
        setUserDataToUserDefaults(user: user)
    }
    private func createUsersTable() {
        let createTable = self.userTable.create{ table in
            table.column(self.id, primaryKey: true)
            table.column(self.name)
            table.column(self.email, unique: true)
            table.column(self.address)
            table.column(self.phone, unique: true)
            table.column(self.password)
        }
        do {
            try self.database.run(createTable)
        }catch {
            print(error.localizedDescription)
        }
    }
    private func listallUsers() {
        do{
            let users = try self.database.prepare(self.userTable)
            for user in users{
                print("user ID:\(user[self.id]), Name: \(user[self.name]), Email: \(user[self.email]), Addrss: \(user[self.address]), Phone: \(user[self.phone]), Password: \(user[self.password])")
            }
        }catch{
            print(error.localizedDescription)
        }
    }
}

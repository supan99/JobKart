//
//  SignUpVC.swift
//  JobKart


import UIKit

class SignUpVC: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtOType: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtCPassword: UITextField!
    
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var btnSignUp: BlueThemeButton!
    
    
    var index = 0
    var flag: Bool = true
    var socialData: SocialLoginDataModel!
    
    
    @IBAction func btn(_ sender: UIButton) {
        if sender == btnSignIn {
            if let vc = UIStoryboard.main.instantiateViewController(withClass: LoginVC.self) {
                vc.index = index
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else if sender == btnSignUp {
            self.flag = false
            let userType = (index == 1) ? jJSeeker : jEmp
            
            let error = self.validation(name: self.txtName.text ?? "", email: self.txtEmail.text ?? "", phone: self.txtPhone.text ?? "", Otype: self.txtOType.text ?? "", password: self.txtPassword.text ?? "", confirmPass: self.txtCPassword.text ?? "")
            
            if error.isEmpty {
                self.firebaseRegister(data: self.txtEmail.text ?? "", password: self.txtPassword.text ?? "", name: self.txtName.text ?? "", mobile: self.txtPhone.text ?? "", organizationType: self.txtOType.text ?? "", usertType: userType)
            }else{
                Alert.shared.showAlert(message: error, completion: nil)
            }
        }
    }
    
    
    private func validation(name: String,email:String,phone:String,Otype:String,password:String,confirmPass:String) -> String {
        if name.isEmpty{
            return STRING.errorEnterName
        }else if email.isEmpty{
            return STRING.errorEmail
        }else if !Validation.isValidEmail(email){
            return STRING.errorValidEmail
        }else if phone.isEmpty{
            return STRING.errorMobile
        }else if !Validation.isValidPhoneNumber(phone) {
            return STRING.errorValidMobile
        }else if Otype.isEmpty {
            return index == 1 ? STRING.errorOccupation : STRING.errorOType
        }else if password.isEmpty {
            return STRING.errorPassword
        } else if password.count < 8 {
            return STRING.errorPasswordCount
        } else if !Validation.isValidPassword(password) {
            return STRING.errorValidCreatePassword
        } else if confirmPass.isEmpty {
            return STRING.errorConfirmPassword
        } else if password != confirmPass {
            return STRING.errorPasswordMismatch
        }
        
        return ""
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if index == 1 {
            self.lblTitle.text = "I’m \nJobSeeker"
            self.txtOType.placeholder = "Occupation"
        }else if index == 2 {
            self.lblTitle.text = "Admin"
        }
        
        if socialData != nil {
            self.txtName.text = "\(socialData.firstName ?? "") \(socialData.lastName ?? "")"
            self.txtEmail.text = socialData.email
            self.txtEmail.isUserInteractionEnabled = false
        }
        // Do any additional setup after loading the view.
    }

}


//MARK:- Extension for Login Function
extension SignUpVC {

    //Firebase Authentication Login
    func firebaseRegister(data: String,password: String, name: String, mobile: String, organizationType: String, usertType: String) {
        FirebaseAuth.Auth.auth().createUser(withEmail: data, password: password) { authResult, error in
            //Return if error find
            
            let uid = FirebaseAuth.Auth.auth().currentUser?.uid ?? ""
            if error != nil {
                Alert.shared.showAlert(message: error?.localizedDescription.description ?? "", completion: nil)
                return
            }else{
                self.createAccount(name: name, email: data, mobile: mobile, password: password, organizationType: organizationType, usertType: usertType,uid: uid)
            }
        }
    }
    
    
    func createAccount(name: String, email: String, mobile: String, password: String, organizationType: String, usertType: String, uid: String) {
    
        var data : [String: Any] = [ jUserType: usertType,
                                          jUID: uid,
                                     jPassword: password,
                                      jIsBlock: false,
                                        jName : name,
                                       jPhone : mobile,
                                        jEmail: email]
        
        if index == 1 {
            data[jName] = name
            data[jPhone] = mobile
            data[jOrgType] = organizationType
        }else{
            data[jJSName] = name
            data[jJSPhone] = mobile
            data[jOccupation] = organizationType
        }
        
        AppDelegate.shared.db.collection(jUser).document(uid).setData(data)
        {  err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                GFunction.user = UserModel(docID: uid, name: name,  mobile: mobile, email: email, password: password, organizationType: organizationType,userType: usertType)
                    
                if #available(iOS 15.0.0, *) {
                    if let vc = UIStoryboard.main.instantiateViewController(withClass: CreateProfileVC.self){
                        vc.index = self.index
                        vc.email = email
                        vc.phone = mobile
                        vc.uid = uid
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                } else {
                    // Fallback on earlier versions
                }
                self.flag = true
            }
        }
    }
}

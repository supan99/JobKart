//
//  LoginVC.swift
//  JobKart

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnSignIn: BlueThemeButton!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    
    var index = 0
    var flag: Bool = true
    var socialData: SocialLoginDataModel!
    
    @IBAction func btnClick(_ sender: UIButton) {
        self.flag = false
        let error = self.validation(email: self.txtEmail.text?.trim() ?? "", password: self.txtPassword.text?.trim() ?? "")
        
        if error.isEmpty {
            if self.txtEmail.text == "Admin@gmail.com" && self.txtPassword.text == "Admin@1234" && index == 2{
                GFunction.isAdmin = true
                UIApplication.shared.setAdmin()
            }else{
                let type = (index == 1) ? jJSeeker : jEmp
                self.firebaseLogin(data: self.txtEmail.text ?? "", password: self.txtPassword.text ?? "", userType: type)
            }
        }else{
            Alert.shared.showAlert(message: error, completion: nil)
        }
       
    }
    
    private func validation(email:String, password:String) -> String {
        if email.isEmpty {
            return STRING.errorEmail
        }else if !Validation.isValidEmail(email) {
            return STRING.errorValidEmail
        }else if password.isEmpty {
            return STRING.errorPassword
        }
        
        return ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if index == 1 {
            self.lblTitle.text = "I’m \nJobSeeker"
        }else if index == 2 {
            self.lblTitle.text = "Admin"
        }
        
        if socialData != nil {
            self.txtEmail.text = socialData.email
            self.txtEmail.isUserInteractionEnabled = false
        }
        // Do any additional setup after loading the view.
    }

}


//MARK:- Extension for Login Function
extension LoginVC {
    
    //Firebase Authentication Login
    func firebaseLogin(data: String, password: String, userType:String) {
        FirebaseAuth.Auth.auth().signIn(withEmail: data, password: password) { [weak self] authResult, error in
            guard self != nil else { return }
            //return if any error find
            if error != nil {
                Alert.shared.showAlert(message: error?.localizedDescription.description ?? "", completion: nil )
            }else{
                let uid = FirebaseAuth.Auth.auth().currentUser?.uid ?? ""
                
                self?.loginUser(uid: uid, userType: userType,password: password)
            }
        }
    }
    
    
    func loginUser(uid: String,userType:String,password: String) {
        _ = AppDelegate.shared.db.collection(jUser).whereField(jUID, isEqualTo: uid).whereField(jUserType, isEqualTo: userType).addSnapshotListener{ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            if snapshot.documents.count != 0 {
                let data1 = snapshot.documents[0].data()
                if let name: String = data1[jName] as? String, let phone: String = data1[jPhone] as? String, let email: String = data1[jEmail] as? String, let oType: String = data1[jOrgType] as? String, let uid: String = data1[jUID] as? String {
                    GFunction.user = UserModel(docID: uid, name: name, mobile: phone, email: email, password: password, organizationType: oType, userType: userType)
                    
                    if userType == jEmp {
                        GFunction.userData = UserDataModel(docID: uid, name: name, mobile: phone, email: email, password: password, organizationType: oType, userType: userType, orgAddress: "", orgName: "", eduLevel: data1[jJSEduLevel] as? String ?? "", skills: data1[jSkills] as? String ?? "", orgImageURL: data1[jJSImageURL] as? String ?? "", aboutMe: data1[jJSAboutMe] as? String ?? "", isBlock: data1[jIsBlock] as? Bool ?? false, exp: data1[jJSExp] as? String ?? "")
                    }else{
                        GFunction.userData = UserDataModel(docID: uid, name: name, mobile: phone, email: email, password: password, organizationType: oType, userType: userType, orgAddress: "", orgName: "", eduLevel: data1[jJSEduLevel] as? String ?? "", skills: data1[jSkills] as? String ?? "", orgImageURL: data1[jJSImageURL] as? String ?? "", aboutMe: data1[jJSAboutMe] as? String ?? "", isBlock: data1[jIsBlock] as? Bool ?? false, exp: data1[jJSExp] as? String ?? "")
                    }
                    
                    
                    
                    GFunction.isAdmin = false
                    if let isBlock: Bool = data1[jIsBlock] as? Bool {
                        if isBlock {
                            Alert.shared.showAlert(message: "Admin blocked you, so contact him again !!!", completion: nil)
                        }else{
                            if self.index == 0 {
                                UIApplication.shared.setEmp()
                            }else if self.index == 1 {
                                UIApplication.shared.setSeeker()
                            }
                        }
                    }
                }
            }else{
                if !self.flag {
                    Alert.shared.showAlert(message: "Please check your credentials !!!", completion: nil)
                    self.flag = true
                }
            }
        }
        
    }
}


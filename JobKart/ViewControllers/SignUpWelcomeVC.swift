//
//  SignUpWelcomeVC.swift
//  JobKart


import UIKit

class SignUpWelcomeVC: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnGoogle: UIButton!
    @IBOutlet weak var btnFB: UIButton!
    @IBOutlet weak var btnSignUp: BlueThemeButton!
    
    
    var index: Int = 0
    private let socialLoginManager: SocialLoginManager = SocialLoginManager()
    
    @IBAction func btnClick(_ sender: UIButton) {
        if sender == btnSignUp {
            if let vc = UIStoryboard.main.instantiateViewController(withClass: SignUpVC.self) {
                vc.index = index
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else if sender == btnGoogle {
            self.socialLoginManager.performAppleLogin()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.socialLoginManager.delegate = self
        
        if index == 1 {
            self.lblTitle.text = "I’m \nJobSeeker"
        }
        
        self.btnFB.layer.cornerRadius = 12.0
        self.btnGoogle.layer.cornerRadius = 12.0
        // Do any additional setup after loading the view.
    }

}


extension SignUpWelcomeVC: SocialLoginDelegate {

    func socialLoginData(data: SocialLoginDataModel) {
        print("Social Id==>", data.socialId ?? "")
        print("First Name==>", data.firstName ?? "")
        print("Last Name==>", data.lastName ?? "")
        print("Email==>", data.email ?? "")
        print("Login type==>", data.loginType ?? "")
        self.loginUser(email: data.email, password: data.socialId,data: data)
    }

    func loginUser(email:String,password:String,data: SocialLoginDataModel) {
        
        _ = AppDelegate.shared.db.collection(jUser).whereField(jEmail, isEqualTo: email).addSnapshotListener{ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            if snapshot.documents.count != 0 {
                if let vc = UIStoryboard.main.instantiateViewController(withClass:  LoginVC.self) {
                    vc.socialData = data
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }else{
                if let vc = UIStoryboard.main.instantiateViewController(withClass:  SignUpVC.self) {
                    vc.socialData = data
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
}

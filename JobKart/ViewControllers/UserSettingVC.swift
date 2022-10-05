//
//  UserSettingVC.swift
//  JobKart


import UIKit
import Firebase
import FirebaseAuth

class UserSettingVC: UIViewController {

    @IBOutlet weak var btnEditProfile: BlueThemeButton!
    @IBOutlet weak var btnChangePassword: BlueThemeButton!
    @IBOutlet weak var btnSignOut: BlueThemeButton!
    
    @IBOutlet weak var txtOldPassword: UITextField!
    @IBOutlet weak var txtNewPassword: UITextField!
    
    var isSelected : Bool = false
    @IBAction func btnClick(_ sender: UIButton) {
        if sender == btnSignOut {
            UIApplication.shared.setStart()
        }else if sender == btnEditProfile {
            if GFunction.user.userType == jJSeeker {
                if let vc = UIStoryboard.main.instantiateViewController(withClass: EditSeekarProfile.self) {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }else{
                if let vc = UIStoryboard.main.instantiateViewController(withClass: EditEMPProfileVC.self) {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }else if sender == btnChangePassword {
            
            if isSelected {
                let error = self.validation(old: self.txtOldPassword.text?.trim() ?? "", new: self.txtNewPassword.text?.trim() ?? "")
                
                if error.isEmpty {
                    Auth.auth().currentUser?.updatePassword(to: self.txtNewPassword.text?.trim() ?? "") { error in
                        if (error != nil) {
                            Alert.shared.showAlert(message: error!.localizedDescription, completion: nil)
                        }else{
                            UIApplication.shared.setStart()
                        }
                    }
                }else{
                    Alert.shared.showAlert(message: error, completion: nil)
                }
                
            }else{
                self.updateView(value: true)
            }
        }
    }
    
    func validation(old: String, new: String) -> String {
        if old.isEmpty {
            return "Please enter old password"
        }else if !self.checkValidPassword(old: old) {
            return "Please enter valid old password"
        }else if new.isEmpty {
            return "Please enter new password"
        }else if old == new {
            return "Please enter different passwords both are same"
        }
        return ""
    }
    
    func checkValidPassword(old: String) -> Bool {
        return GFunction.user.password == old
    }
    
    func updateView(value: Bool) {
        self.isSelected = value
        self.txtNewPassword.isHidden = !value
        self.txtOldPassword.isHidden = !value
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateView(value: false)
        // Do any additional setup after loading the view.
    }
}

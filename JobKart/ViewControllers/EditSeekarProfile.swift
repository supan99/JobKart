//
//  EditSeekarProfile.swift
//  JobKart


import UIKit

class EditSeekarProfile: UIViewController {

    @IBOutlet weak var txtOName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtOType: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtEducationLevel: UITextField!
    @IBOutlet weak var txtJobExp: UITextField!
    @IBOutlet weak var txtSkills: UITextField!
    @IBOutlet weak var txtAboutMe: UITextField!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var btnUpdateProfile: BlueThemeButton!
    
    var index : Int = 0
    var imgPicker = UIImagePickerController()
    var imgPicker1 = OpalImagePickerController()
    var isImageSelected : Bool = false
    var imageURL = ""
    var imgData: UIImage!
    var isChanged: Bool = false
    
    
    
    @IBAction func btnClick(_ sender: UIButton) {
        let error = self.validation()
        if error.isEmpty {
            self.addCreateData(name: self.txtOName.text?.trim() ?? "", phone: self.txtPhone.text?.trim() ?? "", oType: self.txtOType.text?.trim() ?? "", address: self.txtAddress.text?.trim() ?? "", eduLevel: self.txtEducationLevel.text?.trim() ?? "", exp: self.txtJobExp.text?.trim() ?? "", aboutMe: self.txtAboutMe.text?.trim() ?? "", skills: self.txtSkills.text?.trim() ?? "", uid: GFunction.user.docID)
        }else{
            Alert.shared.showAlert(message: error, completion: nil)
        }
    }
    
    private func validation() -> String {

        if self.txtOName.text?.trim() == "" {
            return STRING.errorEnterName
        }else if self.txtPhone.text?.trim() == "" {
            return STRING.errorMobile
        }else if self.txtOType.text?.trim() == "" {
            return STRING.errorOType
        }else if self.txtAddress.text?.trim() == "" {
            return STRING.errorAddress
        }else if self.txtEducationLevel.text?.trim() == "" {
            return STRING.errorEducationLevel
        }else if self.txtJobExp.text?.trim() == "" {
            return STRING.errorJobExp
        }else if self.txtSkills.text?.trim() == "" {
            return STRING.errorSkills
        }else if self.txtAboutMe.text?.trim() == "" {
            return STRING.errorAboutMe
        }
        return ""
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.async {
            self.imgProfile.layer.cornerRadius = self.imgProfile.frame.height / 2
        }
        if GFunction.user != nil {
            self.getData(uid: GFunction.user.docID)
        }
        // Do any additional setup after loading the view.
    }
    
    func getData(uid: String) {
        _ = AppDelegate.shared.db.collection(jUser).whereField(jUID, isEqualTo: uid).addSnapshotListener{ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            if snapshot.documents.count != 0 {
                let data1 = snapshot.documents[0].data()
                if let name: String = data1[jName] as? String, let phone: String = data1[jPhone] as? String, let email: String = data1[jEmail] as? String, let oType: String = data1[jOrgType] as? String, let address: String = data1[jOrgAddress] as? String, let imageURL: String = data1[jOrgImageURL] as? String, let skills: String = data1[jSkills] as? String, let exp: String = data1[jJSExp] as? String, let eduLevel: String = data1[jJSEduLevel] as? String, let aboutme: String = data1[jJSAboutMe] as? String {
                    
                    self.txtEmail.text = email
                    self.txtAddress.text = address
                    self.txtOType.text = oType
                    self.txtPhone.text = phone
                    self.txtOName.text = name
                    self.txtSkills.text = skills
                    self.txtJobExp.text = exp
                    self.txtAboutMe.text = aboutme
                    self.txtEducationLevel.text = eduLevel
                    self.imgProfile.setImgWebUrl(url: imageURL, isIndicator: true)
                    
                    self.txtEmail.isUserInteractionEnabled = false
                }
            }
        }
    }
    
    func addCreateData(name: String, phone: String,oType: String,address: String, eduLevel:String, exp:String, aboutMe: String, skills: String, uid: String) {
        
        let ref = AppDelegate.shared.db.collection(jUser).document(uid)
        
        var data = [
            jName: name,
            jPhone: phone,
            jOrgType: oType,
            jOrgAddress: address,
            jJSEduLevel : eduLevel,
            jJSExp: exp,
            jJSAboutMe: aboutMe,
            jSkills: skills
        ]
        ref.updateData(data){  err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                Alert.shared.showAlert(message: "Your profile has been updated !!!") { Bool in
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}

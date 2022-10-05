//
//  AddPostVC.swift
//  JobKart

import UIKit

class AddPostVC: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtname: UITextField!
    @IBOutlet weak var txtOAddress: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtOType: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtSalary: UITextField!
    @IBOutlet weak var txtDescription: UITextField!
    @IBOutlet weak var txtRequirments: UITextField!
    @IBOutlet weak var btnPost: BlueThemeButton!
    @IBOutlet weak var btnEditPost: BlueThemeButton!
    
    var flag = true
    var isEdit: Bool = false
    var data: PostModel!
    
    private func validation(name: String, oAddress:String, email:String, Otype:String, address:String, salary:String ,description:String, requirement:String ) -> String {
        if name.isEmpty{
            return STRING.errorEnterJobName
        }else if email.isEmpty{
            return STRING.errorEnterJobEmail
        }else if !Validation.isValidEmail(email){
            return STRING.errorValidEmail
        }else if Otype.isEmpty {
            return STRING.errorOType
        }else if oAddress.isEmpty{
            return STRING.errorEnterJobAddress
        }else if salary.isEmpty {
            return STRING.errorEnterJobSalary
        } else if description.isEmpty {
            return STRING.errorEnterJobDescription
        } else if requirement.isEmpty {
            return STRING.errorEnterJobRequirement
        }
        return ""
        
    }
    
    
    @IBAction func btnClick(_ sender: UIButton){
        if sender == btnPost {
            let error = self.validation(name: self.txtname.text?.trim() ?? "", oAddress: self.txtOAddress.text?.trim() ?? "", email: self.txtEmail.text?.trim() ?? "", Otype: self.txtOType.text?.trim() ?? "", address: self.txtAddress.text?.trim() ?? "", salary: self.txtSalary.text?.trim() ?? "", description: self.txtDescription.text?.trim() ?? "", requirement: self.txtRequirments.text?.trim() ?? "")
            
            if error.isEmpty {
                self.flag = false
                self.addCreateData(name: self.txtname.text?.trim() ?? "", oAddress: self.txtOAddress.text?.trim() ?? "", email: self.txtEmail.text?.trim() ?? "", Otype: self.txtOType.text?.trim() ?? "", address: self.txtAddress.text?.trim() ?? "", salary: self.txtSalary.text?.trim() ?? "", description: self.txtDescription.text?.trim() ?? "", requirement: self.txtRequirments.text?.trim() ?? "", user_Email: GFunction.user.email,phone: GFunction.user.mobile)
            }else{
                Alert.shared.showAlert(message: error, completion: nil)
            }
        } else if sender == btnEditPost {
            let error = self.validation(name: self.txtname.text?.trim() ?? "", oAddress: self.txtOAddress.text?.trim() ?? "", email: self.txtEmail.text?.trim() ?? "", Otype: self.txtOType.text?.trim() ?? "", address: self.txtAddress.text?.trim() ?? "", salary: self.txtSalary.text?.trim() ?? "", description: self.txtDescription.text?.trim() ?? "", requirement: self.txtRequirments.text?.trim() ?? "")
            
            if error.isEmpty {
                self.flag = false
                self.updateData(dataID: self.data.docID, name: self.txtname.text?.trim() ?? "", oAddress: self.txtOAddress.text?.trim() ?? "", email: self.txtEmail.text?.trim() ?? "", Otype: self.txtOType.text?.trim() ?? "", address: self.txtAddress.text?.trim() ?? "", salary: self.txtSalary.text?.trim() ?? "", description: self.txtDescription.text?.trim() ?? "", requirement: self.txtRequirments.text?.trim() ?? "", user_Email: GFunction.user.email)
                
            }else{
                Alert.shared.showAlert(message: error, completion: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnPost.isHidden = false
        self.btnEditPost.isHidden = true
        if self.isEdit {
            self.lblTitle.text = "Edit Job"
            self.btnPost.isHidden = true
            self.btnEditPost.isHidden = false
            self.txtname.text = data.job_name.description
            self.txtAddress.text = data.address.description
            self.txtEmail.text = data.job_email.description
            self.txtOType.text = data.job_oType.description
            self.txtSalary.text = data.job_salary.description
            self.txtDescription.text = data.description.description
            self.txtRequirments.text = data.requirement.description
            self.txtOAddress.text = data.job_address.description
        }
        // Do any additional setup after loading the view.
    }
    
    func addCreateData(name: String, oAddress:String, email:String, Otype:String, address:String, salary:String ,description:String, requirement:String, user_Email: String, phone: String) {
        var ref : DocumentReference? = nil
        let data = [
            [isApplied: false,
            isSaved: false,
            jsEmail : GFunction.user.email]
        ]
        ref = AppDelegate.shared.db.collection(jJobs).addDocument(data:
                                                                            [
                                                                                jJobAddress: oAddress,
                                                                                jPostName : name,
                                                                                jOrgType: Otype,
                                                                                jJobEmail: email,
                                                                                jLocation: address,
                                                                                jJobSalary : salary,
                                                                                jJobDescription : description,
                                                                                jRequirement : requirement,
                                                                                jEmpEmail : user_Email,
                                                                                jPhone : phone,
                                                                                jUID: GFunction.user.docID,
                                                                                jsSavedAndApplied: data
                                                                            ])
        {  err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                Alert.shared.showAlert(message: "Job post added successfully !!!") { Bool in
                    if Bool {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
    
    func updateData(dataID: String,name: String, oAddress:String, email:String, Otype:String, address:String, salary:String ,description:String, requirement:String, user_Email: String) {
        let ref = Firestore.firestore().collection(jJobs).document(dataID)
        ref.updateData([
            jJobAddress: oAddress,
            jPostName : name,
            jJobOType: Otype,
            jJobEmail: email,
            jAddress: address,
            jJobSalary : salary,
            jDescription : description,
            jRequirement : requirement,
            jUserEmail : user_Email,
            jUID: GFunction.user.docID
        ]){ err in
            if let err = err {
                print("Error updating document: \(err)")
                self.navigationController?.popViewController(animated: true)
            } else {
                print("Document successfully updated")
                Alert.shared.showAlert(message: "Your profile has been updated successfully !!!") { (true) in
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}


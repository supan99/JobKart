//
//  JobDetailsVC.swift
//  JobKart

import UIKit

class JobDetailsVC: UIViewController {

    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblOName: UILabel!
    @IBOutlet weak var lblRole: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblApplied: UILabel!
    @IBOutlet weak var btnHours: UIButton!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblRequirement: UILabel!
    @IBOutlet weak var lblContactInfo: UILabel!
    @IBOutlet weak var lblAddressInfo: UILabel!
    @IBOutlet weak var btnApplyJob: UIButton!
    @IBOutlet weak var btnSaveJob: UIButton!
    
    var isSeeker : Bool = false
    var isFromAdmin: Bool = false
    var isFav : Bool = true
    var data: PostModel!
    var applyData: ApplyModel!
    
    
    @IBAction func btnClick(_ sender: UIButton) {
        if sender == btnApplyJob {
            if let vc = UIStoryboard.main.instantiateViewController(withClass: ApplyJobVC.self){
                vc.modalTransitionStyle = .crossDissolve
                vc.jobData = self.data
                self.navigationController?.present(vc, animated: true, completion: nil)
            }
        }else if sender == btnSaveJob {
            if isFromAdmin {
                Alert.shared.showAlert("JobKart", actionOkTitle: "Delete", actionCancelTitle: "Cancel", message: "Are you sure you want to delete this job ?") { Bool in
                    self.removeFromPost(data: self.data)
                }
                
            }else{
                self.isFav = false
                self.checkAddToSave(data: data, email: GFunction.user.email )
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.btnSaveJob.isHidden =  isSeeker
        self.btnApplyJob.isHidden = isSeeker
        
        
        self.lblApplied.isHidden = true
        if self.isFromAdmin {
            self.btnSaveJob.isHidden = !isFromAdmin
            self.btnApplyJob.isHidden = isFromAdmin
            self.btnSaveJob.setTitle("Delete Job", for: .normal)
        }
        
        DispatchQueue.main.async {
            self.btnSaveJob.layer.cornerRadius = self.btnSaveJob.frame.height/2
            self.btnApplyJob.layer.cornerRadius = self.btnApplyJob.frame.height/2
            self.btnHours.layer.cornerRadius = self.btnHours.frame.height/2
        }
        self.vwMain.layer.cornerRadius = 23
        
        if data != nil {
            self.lblName.text = data.job_name.description
            self.lblOName.text = data.job_oType.description
            self.lblAddress.text = data.address.description
            self.lblDescription.text = data.description.description
            self.lblAddressInfo.text = data.job_address.description
            self.lblContactInfo.text = data.job_email.description
            self.lblRequirement.text = data.requirement.description
            self.btnHours.setTitle(data.job_salary.description, for: .normal)
        }
        
        if applyData != nil {
            self.lblName.text = applyData.jobName.description
            self.lblOName.text = applyData.jobOtype.description
            self.lblAddress.text = applyData.address.description
            self.getJobData(uid: applyData.jobID)
            self.lblAddressInfo.text = applyData.job_address.description
            self.lblContactInfo.text = applyData.empPhone.description
            self.lblRequirement.text = applyData.jobRequirements.description
            self.btnHours.setTitle(applyData.salary.description, for: .normal)
            
            if applyData.isApproved {
                self.btnSaveJob.isUserInteractionEnabled = false
                self.btnApplyJob.isUserInteractionEnabled = false
                self.btnSaveJob.backgroundColor = UIColor.lightGray
                self.btnApplyJob.backgroundColor = UIColor.lightGray
                self.lblApplied.isHidden = false
            }
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
                    self.savejobs(data: self.data, email: email, exp: exp, imageURL: imageURL, name: name, phone: phone, skills: skills, address: address, about: aboutme)
                }
            }
        }
    }
    
    func getJobData(uid: String) {
        _ = AppDelegate.shared.db.collection(jJobs).whereField(jJobID, isEqualTo: uid).addSnapshotListener{ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            if snapshot.documents.count != 0 {
                let data1 = snapshot.documents[0].data()
                if let jJobDescription: String = data1[jJobDescription] as? String{
                    self.lblDescription.text = jJobDescription.description
                }
            }
        }
    }
    
    
    func savejobs(data: PostModel, email:String,exp:String,imageURL: String,name: String,phone: String,skills:String,address:String,about : String) {
        var ref : DocumentReference? = nil
        ref = AppDelegate.shared.db.collection(jJobSave).addDocument(data:
                                                                        [
                                                                            jEmpEmail: data.user_email,
                                                                            jPhone: data.user_phone,
                                                                            jIsApproved: false,
                                                                            jJobDescription: data.description,
                                                                            jJobID: data.docID,
                                                                            jLocation: data.job_address,
                                                                            jPostName : data.job_name,
                                                                            jJSAboutMe: about,
                                                                            jJSAddress: address,
                                                                            jsEmail: email,
                                                                            jJSExp: exp,
                                                                            jJSImageURL:imageURL,
                                                                            jJSName: name,
                                                                            jJSPhone: phone,
                                                                            jSkills: skills,
                                                                            jOrgAddress: address,
                                                                            jOrgType: data.job_oType,
                                                                            jJobSalary : data.job_salary,
                                                                            jRequirement : data.requirement,
                                                                            jUID: GFunction.user.docID
                                                                        ])
        {  err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                Alert.shared.showAlert(message: "Job has been added into Save list!!!") { (true) in
                    UIApplication.shared.setSeeker()
                }
            }
        }
    }
    
    
    func checkAddToSave(data: PostModel, email:String) {
        _ = AppDelegate.shared.db.collection(jJobSave).whereField(jUserEmail, isEqualTo: email).whereField(jFavID, isEqualTo: data.docID).addSnapshotListener{ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            if snapshot.documents.count == 0 {
                self.isFav = true
                self.getData(uid: GFunction.user.docID)
            }else{
                if !self.isFav {
                    Alert.shared.showAlert(message: "Job has been already existing into Save list!!!", completion: nil)
                }
                
            }
        }
    }
    
    func removeFromPost(data: PostModel){
        let ref = AppDelegate.shared.db.collection(jJobs).document(data.docID)
        ref.delete(){ err in
            if let err = err {
                print("Error updating document: \(err)")
                self.navigationController?.popViewController(animated: true)
            } else {
                print("Document successfully deleted")
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

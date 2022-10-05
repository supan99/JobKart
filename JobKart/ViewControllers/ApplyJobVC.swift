//
//  ApplyJobVC.swift
//  JobKart


import UIKit

class ApplyJobVC: UIViewController {

    
    @IBOutlet weak var vwMain: UIView!
    
    
    var jobData:  PostModel!
    var profileData: UserDataModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.60)
        self.view.isOpaque = true
        let tap = UITapGestureRecognizer()
        tap.addAction {
            self.dismiss(animated: true, completion: nil)
        }
        self.view.addGestureRecognizer(tap)
        self.view.isUserInteractionEnabled = true
        self.vwMain.layer.cornerRadius = 10.0
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnClick(_ sender: UIButton){
        self.applyjobs(data: self.jobData, user: self.profileData)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let uid : String = GFunction.user.docID as? String {
            self.getData(uid: uid)
        }
    }

    func getData(uid: String) {
        _ = AppDelegate.shared.db.collection(jUser).whereField(jUID, isEqualTo: uid).addSnapshotListener{ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            if snapshot.documents.count != 0 {
                for data in snapshot.documents {
                    let data1 = data.data()
                    if  let uid: String = data1[jUID] as? String,
                        let name: String = data1[jName] as? String,
                        let mobile: String = data1[jPhone] as? String,
                        let password: String = data1[jPassword] as? String,
                        let email: String = data1[jEmail] as?  String,
                        let orgType: String = data1[jOrgType] as? String,
                        let userType: String = data1[jUserType] as? String,
                        let address: String = data1[jOrgAddress] as?  String,
                        let isBlock: Bool = data1[jIsBlock] as? Bool {
                        self.profileData = UserDataModel(docID: uid, name: name, mobile: mobile, email: email, password: password, organizationType: orgType, userType: userType, orgAddress: address, orgName: data1[jOrgName] as? String ?? "" , eduLevel: data1[jJSEduLevel] as? String ?? "", skills: data1[jSkills] as? String ?? "", orgImageURL: data1[jOrgImageURL] as? String ?? "", aboutMe: data1[jJSAboutMe] as? String ?? "",isBlock: isBlock, exp: data1[jJSExp] as? String ?? "")
                    }
                }
            }
        }
    }
    
    func applyjobs(data: PostModel, user:UserDataModel) {
        var ref : DocumentReference? = nil
        ref = AppDelegate.shared.db.collection(jApplyJobs).addDocument(data:
                                                                        [
                                                                            jJobDescription: data.description,
                                                                            jJobAddress: data.job_address,
                                                                            jPostName : data.job_name,
                                                                            jJobOType: data.job_oType,
                                                                            jJobEmail: data.job_email,
                                                                            jAddress: data.address,
                                                                            jJobSalary : data.job_salary,
                                                                            jDescription : data.description,
                                                                            jRequirement : data.requirement,
                                                                            jUserEmail : data.user_email,
                                                                            jUID: user.docID,
                                                                            jName: user.name,
                                                                            jPhone: user.mobile,
                                                                            jJSAboutMe: user.aboutMe,
                                                                            jSkills: user.skills,
                                                                            jsEmail: user.email,
                                                                            jJSExp: user.exp,
                                                                            jIsApproved: false,
                                                                            jIsRejected: false,
                                                                            jJobID: data.docID
                                                                        ])
        {  err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                Alert.shared.showAlert(message: "You have applied for this job!!!") { (true) in
                    UIApplication.shared.setSeeker()
                }
            }
        }
    }
}

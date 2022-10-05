//
//  AcceptRejectVC.swift
//  JobKart


import UIKit

class AcceptRejectVC: UIViewController {

    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblAboutme: UILabel!
    @IBOutlet weak var lblSkills: UILabel!
    @IBOutlet weak var lblExp: UILabel!
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var btnReject: UIButton!
    @IBOutlet weak var btnApproved: UIButton!
    
    
    
    @IBAction func btnClick(_ sender: UIButton) {
        if sender == btnReject {
            self.updateData(docID: data.docID, isAccept: false)
        }else if sender == btnApproved {
            self.updateData(docID: data.docID, isAccept: true)
        }
    }
    
    
    var data: ApplyModel!
    override func viewDidLoad() {
        super.viewDidLoad()

        if data != nil {
            self.lblName.text = data.empName.description
            self.lblEmail.text = data.empEmail.description
            self.lblAddress.text = data.address.description
            self.lblPhone.text  = data.empPhone.description
            self.lblAboutme.text = data.job_aboutme.description
            self.lblSkills.text = data.job_Skills.description
            self.lblExp.text  = data.exp.description
            if data.isRejected || data.isApproved {
                self.btnReject.isHidden = true
                self.btnApproved.isHidden = true
            }
        }
        
        
        self.vwMain.layer.cornerRadius = 10.0
        self.btnReject.layer.cornerRadius = 10.0
        self.btnApproved.layer.cornerRadius = 10.0
        // Do any additional setup after loading the view.
    }
    
    func updateData(docID: String, isAccept: Bool) {
        
        let ref = AppDelegate.shared.db.collection(jApplyJobs).document(docID)
        let jobRef = AppDelegate.shared.db.collection(jJobs).document(self.data.jobID)
        var data = [String:Bool]()
        
        let datajob = [[
            isApplied: isAccept,
            isSaved: !isAccept,
            jsEmail: self.data.empEmail
        ]]
        
        if isAccept {
            data = [
                jIsApproved: true
            ]
        }else{
            data = [
                jIsRejected: true
            ]
        }
        
        
        ref.updateData(data){  err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                jobRef.updateData([
                    jsSavedAndApplied: datajob
                ]){  err in
                    if let err = err {
                        self.navigationController?.popViewController(animated: true)
                        print("Error adding document: \(err)")
                    } else {
                        if isAccept {
                            self.emailSend(email: self.data.empEmail, name: self.data.empName)
                        }else{
                            self.navigationController?.popViewController(animated: true)
                        }
                        
                    }
                }
            }
        }
    }
    
    func emailSend(email: String, name:String){
        self.sendEmail(email: email, name:name){ [unowned self] (result) in
            DispatchQueue.main.async {
                switch result{
                    case .success(_):
                        Alert.shared.showAlert(message: "You approved this job !!!") { (true) in
                            self.navigationController?.popViewController(animated: true)
                        }
                    case .failure(_):
                        Alert.shared.showAlert(message: "Error", completion: nil)
                }
            }
            
        }
    }
    
    func sendEmail(email: String, name:String, completion: @escaping (Result<Void,Error>) -> Void) {
        let apikey = "" ///SG API KEY
        let devemail = "" //DEV ACCOUNT EMAIL ID
        
        let data : [String:String] = [
            "email": email,
            "name": name,
        ]
        
        
        let personalization = TemplatedPersonalization(dynamicTemplateData: data, recipients: email)
        let session = Session()
        session.authentication = Authentication.apiKey(apikey)
        
        let from = Address(email: devemail, name: "JOBKART")
        let template = Email(personalizations: [personalization], from: from, templateID: "", subject: "Your job has been approved!!!") //TEMPLATE ID
        
        do {
            try session.send(request: template, completionHandler: { (result) in
                switch result {
                    case .success(let response):
                        print("Response : \(response)")
                        completion(.success(()))
                        
                    case .failure(let error):
                        print("Error : \(error)")
                        completion(.failure(error))
                }
            })
        }catch(let error){
            print("ERROR: ")
            completion(.failure(error))
        }
    }
}

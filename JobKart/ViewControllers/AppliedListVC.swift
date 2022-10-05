//
//  AppliedListVC.swift
//  JobKart


import UIKit

class AppliedListVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "JobCell", for: indexPath) as! JobCell
        let data = self.array[indexPath.row]
        cell.configCellApply(data: data)
        let tap = UITapGestureRecognizer()
        tap.addAction {
            if let vc = UIStoryboard.main.instantiateViewController(withClass: AcceptRejectVC.self){
                vc.data = data
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        cell.vwMain.isUserInteractionEnabled = true
        cell.vwMain.addGestureRecognizer(tap)
        return cell
    }
    

    
    var array = [ApplyModel]()
    
    @IBOutlet weak var tblList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getData(email: GFunction.user.email)
    }
    
    
    func getData(email: String) {
        _ = AppDelegate.shared.db.collection(jApplyJobs).whereField(jUserEmail, isEqualTo: email).addSnapshotListener{ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            self.array.removeAll()
            if snapshot.documents.count != 0 {
                for data in snapshot.documents {
                    let data1 = data.data()
                    if  let job_address: String = data1[jJobAddress] as? String,
                        let name: String = data1[jName] as? String,
                        let mobile: String = data1[jPhone] as? String,
                        let jobname: String = data1[jPostName] as? String,
                        let address: String = data1[jAddress] as?  String,
                        let isReject: Bool = data1[jIsRejected] as? Bool,
                        let isAccept: Bool = data1[jIsApproved] as? Bool,
                        let requirements: String = data1[jRequirement] as?  String,
                        let oType: String = data1[jJobOType] as?  String,
                        let salary: String = data1[jJobSalary] as?  String,
                        let uid: String = data1[jUID] as? String,
                        let aboutMe: String = data1[jJSAboutMe] as? String,
                        let skills: String = data1[jSkills] as? String,
                        let jobID: String = data1[jJobID] as? String,
                        let jobDescription: String = data1[jJobDescription] as? String
                    {
                    self.array.append(ApplyModel(docId: data.documentID, empName: name, empPhone: mobile, empEmail: data1[jsEmail] as? String ?? "", isApproved: isAccept, isRejected: isReject, jobName: jobname, jobRequirements: requirements, jobOtype: oType, job_aboutme: aboutMe, job_Skills: skills, salary: salary, address: address, job_address: job_address, uid: uid,jobID: jobID,jobDescription: jobDescription, exp: data1[jJSExp] as? String ?? ""))
                    }
                }
                
                self.tblList.delegate = self
                self.tblList.dataSource = self
                self.tblList.reloadData()
            }else{
                Alert.shared.showAlert(message: "NO Data Found !!!", completion: nil)
            }
        }
    }
}

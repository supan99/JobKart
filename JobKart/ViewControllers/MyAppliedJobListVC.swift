//
//  MyAppliedJobListVC.swift
//  JobKart


import UIKit

class MyAppliedJobListVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchSeekerCell", for: indexPath) as! SearchSeekerCell
        cell.configCellApplied(data: self.array[indexPath.row])
        
        let tap = UITapGestureRecognizer()
        tap.addAction {
            if let vc = UIStoryboard.main.instantiateViewController(withClass: JobDetailsVC.self){
                vc.applyData = self.array[indexPath.row]
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        cell.vwMain.addGestureRecognizer(tap)
        cell.vwMain.isUserInteractionEnabled = true
        return cell
    }
    
    var array = [ApplyModel]()
    
    
    
    @IBOutlet weak var tblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getData(uid: GFunction.user.docID)
    }
    
    func getData(uid: String) {
        _ = AppDelegate.shared.db.collection(jApplyJobs).whereField(jUID, isEqualTo: uid).addSnapshotListener{ querySnapshot, error in
            
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
                        let jJobOrgType: String = data1[jJobOType] as? String,
                        let address: String = data1[jAddress] as?  String,
                        let isReject: Bool = data1[jIsRejected] as? Bool,
                        let isAccept: Bool = data1[jIsApproved] as? Bool,
                        let requirements: String = data1[jRequirement] as?  String,
                        let salary: String = data1[jJobSalary] as?  String,
                        let uid: String = data1[jUID] as? String,
                        let aboutMe: String = data1[jJSAboutMe] as? String,
                        let skills: String = data1[jSkills] as? String,
                        let jobID: String = data1[jJobID] as? String,
                        let jobDescription: String = data1[jJobDescription] as? String {
                        self.array.append(ApplyModel(docId: data.documentID, empName: name, empPhone: mobile, empEmail: data1[jEmpEmail] as? String ?? "", isApproved: isAccept, isRejected: isReject, jobName: jobname, jobRequirements: requirements, jobOtype: jJobOrgType, job_aboutme: aboutMe, job_Skills: skills, salary: salary, address: address, job_address: job_address, uid: uid, jobID: jobID,jobDescription: jobDescription, exp: data1[jJSExp] as? String ?? ""))
                    }
                }
                
                self.tblView.delegate = self
                self.tblView.dataSource = self
                self.tblView.reloadData()
            }else{
                Alert.shared.showAlert(message: "NO Data Found !!!", completion: nil)
            }
        }
    }

}

//
//  EditPostListVC.swift
//  JobKart


import UIKit

class EditPostListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavePostCell", for: indexPath) as! SavePostCell
        let data = self.array[indexPath.row]
        cell.configCell(data: data)
        cell.btnUnsaved.setTitle("Delete Job", for: .normal)
        cell.btnApply.setTitle("Edit Job", for: .normal)
        cell.btnUnsaved.addAction(for: .touchUpInside) {
            Alert.shared.showAlert("JobCart", actionOkTitle: "Remove", actionCancelTitle: "Cancel", message: "Are you sure you want to remove this job?") { Bool in
                if Bool {
                    self.removeFromPost(data: data)
                }
            }
        }
        cell.btnApply.addAction(for: .touchUpInside) {
            if let vc = UIStoryboard.main.instantiateViewController(withClass: AddPostVC.self) {
                vc.isEdit = true
                vc.data = data
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        return cell
    }
    

    @IBOutlet weak var tblLsit: UITableView!
    
    
    var array = [PostModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getData()
    }
    
    func getData() {
        _ = AppDelegate.shared.db.collection(jJobs).whereField(jUID, isEqualTo: GFunction.user.docID).addSnapshotListener{ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            self.array.removeAll()
            if snapshot.documents.count != 0 {
                for data in snapshot.documents {
                    let data1 = data.data()
                    if  let job_address: String = data1[jJobAddress] as? String,
                        let job_name: String = data1[jPostName] as? String,
                        let job_oType: String = data1[jOrgType] as? String,
                        //                        let job_email: String = data1[jJobEmail] as? String,
                        let address: String = data1[jLocation] as?  String,
                        let job_salary: String = data1[jJobSalary] as? String,
                        let description: String = data1[jJobDescription] as? String,
                        let requirement: String = data1[jRequirement] as? String,
                        let emp_email: String = data1[jEmpEmail] as? String,
                        let emp_Phone: String = data1[jPhone] as? String,
                        let saveAndApply = data1[jsSavedAndApplied] as? [[String:Any]]
                    {
                    self.array.append(PostModel(docId: data.documentID, job_address: job_address, job_name: job_name, job_oType: job_oType, job_email:  data1[jJobEmail] as? String ?? "", address: address, job_salary: job_salary, description: description, requirement: requirement, user_email: emp_email,user_Phone: emp_Phone,uid: data1[jUID] as? String ?? "",favID: "", saveAndApply: saveAndApply))
                    }
                }
                self.tblLsit.delegate = self
                self.tblLsit.dataSource = self
                self.tblLsit.reloadData()
            }else{
                Alert.shared.showAlert(message: "No Data Found !!!", completion: nil)
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

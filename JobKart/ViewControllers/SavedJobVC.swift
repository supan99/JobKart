//
//  SavedJobVC.swift
//  JobKart

import UIKit

class SavedJobVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SaveJobCell", for: indexPath) as! SaveJobCell
        let data = self.array[indexPath.row]
        cell.configCell(data: data)
        
        cell.btnUnsaved.addAction(for: .touchUpInside) {
            Alert.shared.showAlert("JobCart", actionOkTitle: "Remove", actionCancelTitle: "Cancel", message: "Are you sure you want to remove this job from save?") { Bool in
                if Bool {
                    self.removeFromPost(data: data)
                }
            }
        }
        
        cell.btnApply.addAction(for: .touchUpInside) {
            if let vc = UIStoryboard.main.instantiateViewController(withClass: ApplyJobVC.self){
                vc.modalPresentationStyle = .fullScreen
                self.navigationController?.present(vc, animated: true, completion: nil)
            }
        }
        
        
        cell.btnApply.isHidden = true
        return cell
    }
    
    
    func removeFromPost(data: SavedPostModel){
        let ref = AppDelegate.shared.db.collection(jJobSave).document(data.docID)
        ref.delete(){ err in
            if let err = err {
                print("Error updating document: \(err)")
                self.navigationController?.popViewController(animated: true)
            } else {
                print("Document successfully deleted")
                UIApplication.shared.setEmp()
            }
        }
    }

    @IBOutlet weak var tblList: UITableView!
    
    var array = [SavedPostModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getData()
    }
    
    func getData() {
        _ = AppDelegate.shared.db.collection(jJobSave).whereField(jUID, isEqualTo: GFunction.user.docID).addSnapshotListener{ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            self.array.removeAll()
            if snapshot.documents.count != 0 {
                for data in snapshot.documents {
                    let data1 = data.data()
                    if  let jEmpEmail: String = data1[jEmpEmail] as? String,
                        let jPhone: String = data1[jPhone] as? String,
                        let jIsApproved: Bool = data1[jIsApproved] as? Bool,
                        let jJobDescription: String = data1[jJobDescription] as?  String,
                        let jJobID: String = data1[jJobID] as? String,
                        let jLocation: String = data1[jLocation] as? String,
                        let jPostName: String = data1[jPostName] as? String,
                        let jJSAboutMe: String = data1[jJSAboutMe] as? String,
                        let jJSAddress: String = data1[jJSAddress] as? String,
                        let jsEmail: String = data1[jsEmail] as? String,
                        let jJSExp: String = data1[jJSExp] as? String,
                        let jJSImageURL: String = data1[jJSImageURL] as? String,
                        let jJSPhone: String = data1[jJSPhone] as? String,
                        let jSkills: String = data1[jSkills] as? String,
                        let jJSName: String = data1[jJSName] as? String,
                        let jOrgAddress: String = data1[jOrgAddress] as? String,
                        let jOrgType: String = data1[jOrgType] as? String,
                        let jJobSalary: String = data1[jJobSalary] as? String,
                        let jRequirement: String = data1[jRequirement] as? String,
                        let uid: String = data1[jUID] as? String
                    {
                    
                    self.array.append(SavedPostModel(docId: data.documentID, jEmpEmail: jEmpEmail, jPhone: jPhone, jIsApproved: jIsApproved, jJobDescription: jJobDescription, jJobID: jJobID, jLocation: jLocation, jPostName: jPostName, jJSAboutMe: jJSAboutMe, jJSAddress: jJSAddress, jsEmail: jsEmail, jJSExp: jJSExp, jJSImageURL: jJSImageURL, jJSName: jJSName, jJSPhone: jJSPhone, jSkills: jSkills, jOrgAddress: jOrgAddress, jOrgType: jOrgType, jJobSalary: jJobSalary, jRequirement: jRequirement, uid: uid))
                    }
                }
                
                self.tblList.delegate = self
                self.tblList.dataSource = self
                self.tblList.reloadData()
            }else{
                self.tblList.reloadData()
                Alert.shared.showAlert(message: "No Data Found !!!", completion: nil)
            }
        }
    }
}



class SaveJobCell: UITableViewCell {
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblOName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var btnHours: UIButton!
    @IBOutlet weak var btnApply: UIButton!
    @IBOutlet weak var btnUnsaved: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.vwMain.layer.cornerRadius = 23.0
        DispatchQueue.main.async {
            self.btnApply.layer.cornerRadius = self.btnApply.frame.height/2
            self.btnHours.layer.cornerRadius = self.btnHours.frame.height/2
            self.btnUnsaved.layer.cornerRadius = self.btnUnsaved.frame.height/2
        }
    }
    
    func configCell(data: SavedPostModel) {
        self.lblName.text = data.jPostName.description
        self.lblAddress.text = data.jOrgAddress.description
        self.btnHours.setTitle("$\(data.jJobSalary.description) an hour", for: .normal)
        self.lblOName.text = data.jOrgType.description
    }
}


class SavePostCell: UITableViewCell {
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblOName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var btnHours: UIButton!
    @IBOutlet weak var btnApply: UIButton!
    @IBOutlet weak var btnUnsaved: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.vwMain.layer.cornerRadius = 23.0
        DispatchQueue.main.async {
            self.btnApply.layer.cornerRadius = self.btnApply.frame.height/2
            self.btnHours.layer.cornerRadius = self.btnHours.frame.height/2
            self.btnUnsaved.layer.cornerRadius = self.btnUnsaved.frame.height/2
        }
    }
    
    func configCell(data: PostModel) {
        self.lblName.text = data.job_name.description
        self.lblAddress.text = data.job_address.description
        self.btnHours.setTitle(data.job_salary, for: .normal)
        self.lblOName.text = data.job_oType.description
    }
}

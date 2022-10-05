//
//  AdminCandidateVC.swift
//  JobKart

import UIKit

class AdminCandidateVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "JobCell", for: indexPath) as! JobCell
        let data = self.array[indexPath.row]
        cell.configCell(data: data)
        let tap = UITapGestureRecognizer()
        tap.addAction {
            if self.data == jJSeeker {
                if let vc = UIStoryboard.main.instantiateViewController(withClass: RecruiterProfileVC.self) {
                    vc.data = data
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }else{
                if let vc = UIStoryboard.main.instantiateViewController(withClass: EmployeeProfileVC.self) {
                    vc.data = data
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
        
        cell.vwMain.isUserInteractionEnabled = true
        cell.vwMain.addGestureRecognizer(tap)
        
        return cell
    }
    

    @IBOutlet weak var btnSeeker: UIButton!
    @IBOutlet weak var tblList: UITableView!
    
    var array = [UserDataModel]()
    var data: String = ""
    
    
    @IBAction func btnClick(_ sender: UIButton){
        self.openPicker()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.btnSeeker.layer.cornerRadius = self.btnSeeker.frame.height/2
        }
        self.btnSeeker.setTitle(jJSeeker, for: .normal)
        self.getData(type: jJSeeker)
        self.data = jJSeeker
        self.tblList.delegate = self
        self.tblList.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
    func openPicker(){
        
        let actionSheet = UIAlertController(title: nil, message: "", preferredStyle: .actionSheet)
        
        let recruiter = UIAlertAction(title: "Recruiter", style: .default, handler: {
            (alert: UIAlertAction) -> Void in
            self.getData(type: jJSeeker)
            self.data = jJSeeker
            self.btnSeeker.setTitle(jJSeeker, for: .normal)
            
        })
        
        let employee = UIAlertAction(title: "Employee", style: .default, handler:
                                            {
            (alert: UIAlertAction) -> Void in
            self.getData(type: jEmp)
            self.data = jEmp
            self.btnSeeker.setTitle(jEmp, for: .normal)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction) -> Void in
            
        })
        
        actionSheet.addAction(recruiter)
        actionSheet.addAction(employee)
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    
    func getData(type: String) {
        _ = AppDelegate.shared.db.collection(jUser).whereField(jUserType, isEqualTo: type).addSnapshotListener{ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            self.array.removeAll()
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
                        self.array.append(UserDataModel(docID: uid, name: name, mobile: mobile, email: email, password: password, organizationType: orgType, userType: userType, orgAddress: address, orgName: data1[jOrgName] as? String ?? "" , eduLevel: data1[jJSEduLevel] as? String ?? "", skills: data1[jSkills] as? String ?? "", orgImageURL: data1[jOrgImageURL] as? String ?? "", aboutMe: data1[jJSAboutMe] as? String ?? "",isBlock: isBlock, exp: data1[jJSExp] as? String ?? ""))
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



class JobCell: UITableViewCell {
    
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var btnApply: UIButton!
    
    
    
    override func awakeFromNib() {
        self.vwMain.layer.cornerRadius = 23.0
        DispatchQueue.main.async {
            self.btnApply.layer.cornerRadius = self.btnApply.frame.height/2
            self.imgProfile.layer.cornerRadius = self.imgProfile.frame.height/2
        }
    }
    
    func configCell(data: UserDataModel) {
        self.lblName.text = data.name.description
        self.lblPhone.text = data.mobile.description
        self.lblAddress.text = data.orgAddress.description
    }
    
    func configCellApply(data: ApplyModel) {
        self.lblName.text = data.empName.description
        self.lblPhone.text = data.empPhone.description
        self.lblAddress.text = data.address.description
    }
}

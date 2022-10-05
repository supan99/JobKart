//
//  RecruiterProfileVC.swift
//  JobKart


import UIKit



class RecruiterProfileVC: UIViewController {

    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var btnBlock: UIButton!
    @IBOutlet weak var btnUnBlock: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblRole: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblDesription: UILabel!
    @IBOutlet weak var lblRequirements: UILabel!
    @IBOutlet weak var lblContactInfo: UILabel!
    @IBOutlet weak var lblAddressInfo: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    
    
    var data: UserDataModel!
    
    @IBAction func btnClick(_ sender: UIButton) {
        if sender == btnBlock {
            self.blockData(uid: data.docID, isBlock: true)
        }else if sender == btnUnBlock {
            self.blockData(uid: data.docID, isBlock: false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.async {
            self.vwMain.layer.cornerRadius = 23.0
            self.btnBlock.layer.cornerRadius = self.btnBlock.frame.height/2
            self.btnUnBlock.layer.cornerRadius = self.btnUnBlock.frame.height/2
        }
        
        if data != nil {
            self.lblName.text = data.name.description
            self.lblAddress.text = data.orgAddress.description
            self.lblContactInfo.text  = "Email: \(data.email.description)\nMobile: \(data.mobile.description)"
            self.lblAddressInfo.text = data.orgAddress.description
            
        }
        // Do any additional setup after loading the view.
    }
    
    func blockData(uid: String,isBlock: Bool) {
        let ref = AppDelegate.shared.db.collection(jUser).document(uid)
        ref.updateData([
            jIsBlock: isBlock,
        ]){  err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                UIApplication.shared.setAdmin()
//                self.navigationController?.popViewController(animated: true)
            }
        }
    }

}

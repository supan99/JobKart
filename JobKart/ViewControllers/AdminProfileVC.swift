//
//  AdminProfileVC.swift
//  JobKart

import UIKit

class AdminProfileVC: UIViewController {

    @IBOutlet weak var btnSignOut: BlueThemeButton!
    
    @IBAction func btnClick(_ sender: UIButton) {
        UIApplication.shared.setStart()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.navigationBar.isHidden = false
    }
}

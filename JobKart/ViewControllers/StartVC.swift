//
//  StartVC.swift
//  JobKart


import UIKit

class StartVC: UIViewController {
    
    @IBOutlet weak var btnAdmin: BlueThemeButton!
    @IBOutlet weak var btnEmp: BlueThemeButton!
    @IBOutlet weak var btnSeeker: BlueThemeButton!
    

    @IBAction func btnClick(_ sender: BlueThemeButton) {
        if sender == btnAdmin {
            if let vc = UIStoryboard.main.instantiateViewController(withClass: LoginVC.self) {
                vc.index = 2
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else{
            if let vc = UIStoryboard.main.instantiateViewController(withClass: SignUpWelcomeVC.self) {
                vc.index = sender == btnEmp ? 0 : 1
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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

}

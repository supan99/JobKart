//
//  WelcomeVC.swift
//  JobKart


import UIKit

class WelcomeVC: UIViewController {

    @IBAction func btnGetStartedClick(_ sender: UIButton) {
        
        if let vc = UIStoryboard.main.instantiateViewController(withClass: StartVC.self) {
            self.navigationController?.pushViewController(vc, animated: true)
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

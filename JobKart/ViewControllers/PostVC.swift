//
//  PostVC.swift
//  JobKart


import UIKit

class PostVC: UIViewController {

    @IBOutlet weak var btnAdDPost: BlueThemeButton!
    @IBOutlet weak var btnEditPost: BlueThemeButton!
    
    
    @IBAction func btnClick(_ sender: UIButton) {
        if sender == btnAdDPost {
            if let vc = UIStoryboard.main.instantiateViewController(withClass: AddPostVC.self) {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else if sender == btnEditPost {
            if let vc = UIStoryboard.main.instantiateViewController(withClass: EditPostListVC.self) {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}

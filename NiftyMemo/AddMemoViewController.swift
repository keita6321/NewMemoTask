//
//  NewMemoViewController.swift
//  NiftyMemo
//
//  Created by nttr on 2017/09/12.
//  Copyright © 2017年 nttr. All rights reserved.
//

import UIKit
import NCMB
import SVProgressHUD

class AddMemoViewController: UIViewController {

    @IBOutlet var memoTextView:UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func save(){
        let object = NCMBObject(className: "Memo")
        object?.setObject(memoTextView.text, forKey: "text")
        
        object?.saveInBackground({ (error) in
            if error != nil{
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
            }
            else{
                print("メモの追加が完了")
            }
        })
        self.navigationController?.popViewController(animated: true)
    }
}

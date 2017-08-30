//
//  DetailViewController.swift
//  NiftyMemo
//
//  Created by nttr on 2017/08/23.
//  Copyright © 2017年 nttr. All rights reserved.
//

import UIKit
import NCMB

class DetailViewController: UIViewController {

    @IBOutlet var memoTextView: UITextView!
    var selectedMemo: NCMBObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        memoTextView.text = selectedMemo.object(forKey: "text") as! String
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func update(){
        selectedMemo.setObject(memoTextView.text, forKey: "text")
        selectedMemo.saveInBackground { (error) in
            if error != nil{
                print(error)
            }
            else{
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

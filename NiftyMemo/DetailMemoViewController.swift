//
//  DetailViewController.swift
//  NiftyMemo
//
//  Created by nttr on 2017/08/23.
//  Copyright © 2017年 nttr. All rights reserved.
//

import UIKit
import NCMB
import SVProgressHUD

class DetailMemoViewController: UIViewController {
    
    @IBOutlet var textDatePicker: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    //var limit :String = ""
    @IBOutlet var saveButton: UIButton!
    
    @IBOutlet var memoTextView: UITextView!
    var selectedMemo: NCMBObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        memoTextView.text = selectedMemo.object(forKey: "text") as! String
        //datePicker.date = selectedMemo.object(forKey: "limit") as! Date
        
        saveButton.frame.size.height = saveButton.frame.width // ボタンを正方形にする
        saveButton.layer.cornerRadius = saveButton.frame.width / 2 // 角丸のサイズ（丸ボタン）
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //------------------------------
    
    
    //メモの内容を変更
    @IBAction func update(){
        selectedMemo.setObject(memoTextView.text, forKey: "text")        
        selectedMemo.saveInBackground { (error) in
            if error != nil{
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
            }
            else{
                print("update memo")
                self.postNotification()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }

    func postNotification() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateMemo"), object: nil, userInfo: ["updateMemoFlag": true])
    }
    
}

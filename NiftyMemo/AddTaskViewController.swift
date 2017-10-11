//
//  AddMemoViewController.swift
//  NiftyMemo
//
//  Created by nttr on 2017/08/23.
//  Copyright © 2017年 nttr. All rights reserved.
//

import UIKit
import NCMB
import SVProgressHUD
import UserNotifications

class AddTaskViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet var textDatePicker: UITextField!
    @IBOutlet var saveButton: UIButton!
    
    let datePicker = UIDatePicker()
    let center = UNUserNotificationCenter.current()
    
    @IBOutlet weak var datePicker2: UIDatePicker!
    @IBOutlet var memoTextView: UITextView!
    @IBOutlet var noticeTest: UITextField!
    var str: String!
    
    @IBOutlet weak var pickerLabel1: UILabel!
    @IBOutlet weak var pickerLabel2: UILabel!
    @IBOutlet weak var alertCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton.frame.size.height = saveButton.frame.width // ボタンを正方形にする
        saveButton.layer.cornerRadius = saveButton.frame.width / 2 // 角丸のサイズ（丸ボタン）
    }
    
    override func viewDidAppear(_ animated: Bool) {
        memoTextView.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //キーボードのリターンが押されたときの処理
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        str = textField.text!
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func pickerValueChanged(_ sender: Any) {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        let formatter2 = DateFormatter()
        var now = Date()
        var count = calendar.dateComponents([.second], from: now, to: datePicker2.date).second
        formatter.dateFormat = "YYYY/MM/dd"
        //pickerLabel1.text = formatter.string(from: datePicker2.date)
        formatter2.dateFormat = "hh:mm a"
        //pickerLabel2.text = formatter2.string(from: datePicker2.date)
        
        //alertCountLabel.text = String(describing: count!)
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "YYYY/MM/dd hh:mm a"
        print("start\(formatter3.string(from: now))")
        print("end\(formatter3.string(from: datePicker2.date))")
        print(String(describing: count!))
        
    }
    
    
    @IBAction func save(){
        
        SVProgressHUD.show(withStatus: "保存中...")
        //
        let object = NCMBObject(className: "NiftyMemo")
        object?.setObject(memoTextView.text, forKey: "text")
        //object?.setObject(textDatePicker.text, forKey: "limit")
        object?.setObject(datePicker2.date, forKey: "limit")
        object?.setObject(false, forKey: "done")
        object?.setObject(false, forKey: "today")
        object?.setObject(false, forKey: "expired")
        
        object?.saveInBackground({ (error) in
            if error != nil{
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
            } else {
                print("更新できそう")
                //self.postNotification()
                SVProgressHUD.dismiss()
                self.navigationController?.popViewController(animated: true)
            }
        })
        
        let content = UNMutableNotificationContent()
        let calendar = Calendar.current
        let now = Date()
        if(datePicker2.date>now){
            content.title = "タスク期限の通知";
            content.body = object?.object(forKey: "text") as! String
            content.sound = UNNotificationSound.default()
            var count = calendar.dateComponents([.second], from: now, to: datePicker2.date).second
            let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: TimeInterval(count as! Int), repeats: false)
            let request = UNNotificationRequest.init(identifier: "Alert", content: content, trigger: trigger)
            center.add(request)
            print("アラートをセットしました")
        }
        
    }
    
    @IBAction func save2(){

    }

    func postNotification() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addTask"), object: nil, userInfo: ["addTaskFlag": true])
    }
    
}


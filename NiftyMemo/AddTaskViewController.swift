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
        //noticeTest.delegate = self
        //showDatePicker()
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
    
    //--------datepicker------------
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        print(type(of: toolbar))
        
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.bordered, target: self, action: "donedatePicker")
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.bordered, target: self, action: "cancelDatePicker")
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        // add toolbar to textField
        //textDatePicker.inputAccessoryView = toolbar
        // add datepicker to textField
        datePicker.datePickerMode = UIDatePickerMode.date
        //textDatePicker.inputView = datePicker
    }
    
    func donedatePicker(){
        //For date formate
        let formatter = DateFormatter()
        //formatter.locale = Locale(identifier: "ja_JP")
        //formatter.dateFormat = "yyyy-MM-dd HH:mm:ss zzz"
        formatter.dateFormat = "yyyy-MM-dd"
        textDatePicker.text = formatter.string(from: datePicker.date)
        //dismiss date picker dialog
        self.view.endEditing(true)
    }
    
    func cancelDatePicker(){
        //cancel button dismiss datepicker dialog
        self.view.endEditing(true)
    }
    
    //------------------------------
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
    }
    
    
    @IBAction func save(){
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
            }
            else{
                print("更新できそう")
            }
        })
        
        let content = UNMutableNotificationContent()
        let calendar = Calendar.current
        let now = Date()
        if(datePicker2.date>now){
            content.title = "期限の確認";
            content.body = object?.object(forKey: "text") as! String
            content.sound = UNNotificationSound.default()
            var count = calendar.dateComponents([.second], from: now, to: datePicker2.date).second
            let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: TimeInterval(count as! Int), repeats: false)
            let request = UNNotificationRequest.init(identifier: "Alert", content: content, trigger: trigger)
            center.add(request)
            print("アラートをセットしました")
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func save2(){
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
            }
            else{
                self.navigationController?.popViewController(animated: true)
            }
        })
        
        let content = UNMutableNotificationContent()
        let calendar = Calendar.current
        let now = Date()
        if(datePicker2.date>now){
            content.title = "スケジュール";
            content.body = "さっさとやろう";
            content.sound = UNNotificationSound.default()
            var count = calendar.dateComponents([.second], from: now, to: datePicker2.date).second
            let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: TimeInterval(count as! Int), repeats: false)
            let request = UNNotificationRequest.init(identifier: "Alert", content: content, trigger: trigger)
            center.add(request)
            print("アラートをセットしました")
        }
        self.navigationController?.popViewController(animated: true)
    }

}


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
import UserNotificationsUI
import UserNotifications

class AddMemoViewController: UIViewController, UITextFieldDelegate, UNUserNotificationCenterDelegate {
    
    
    @IBOutlet var textDatePicker: UITextField!
    let datePicker = UIDatePicker()
    
    @IBOutlet var memoTextView: UITextView!
    @IBOutlet var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showDatePicker()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        memoTextView.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        textDatePicker.inputAccessoryView = toolbar
        // add datepicker to textField
        datePicker.datePickerMode = UIDatePickerMode.date
        textDatePicker.inputView = datePicker
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
    
    @IBAction func addLabel(){
        
        
    }
    
    @IBAction func save(){
        let object = NCMBObject(className: "NiftyMemo")
        object?.setObject(memoTextView.text, forKey: "text")
        object?.setObject(textDatePicker.text, forKey: "limit")
        object?.setObject(false, forKey: "today")
        object?.setObject(false, forKey: "done")
        object?.setObject(false, forKey: "expired")
        //object?.setObject("テスト", forKey: "label")
        
        object?.saveInBackground({ (error) in
            if error != nil{
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
            }
            else{
                //let alertController = UIAlertController(title: "保存完了", message: "メモの保存が完了。メモ一覧に戻ります", preferredStyle: .alert)
                //    let action = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                self.navigationController?.popViewController(animated: true)
                //    })
                //    alertController.addAction(action)
                //    self.present(alertController, animated: true, completion: nil)
            }
        })
        //---------------------------------------
        //if #available(iOS 10.0, *) {
            // iOS 10
        //    let center = UNUserNotificationCenter.current()
        //    center.requestAuthorization(options: [.badge, .sound, .alert], completionHandler: { (granted, error) in
        //        if error != nil {
        //            return
        //        }
                
        //        if granted {
        //            print("通知許可")
        //            let center = UNUserNotificationCenter.current()
        //            center.delegate = self as! UNUserNotificationCenterDelegate
        //        } else {
        //            print("通知拒否")
        //        }
        //    })
            
        //} else {
            // iOS 9以下
        //    let settings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
        //    UIApplication.shared.registerUserNotificationSettings(settings)
        //}
        //---------------------------------------
    }
    @IBAction func save2(){
        let object = NCMBObject(className: "NiftyMemo")
        object?.setObject(memoTextView.text, forKey: "text")
        object?.setObject(textDatePicker.text, forKey: "limit")
        object?.setObject(false, forKey: "today")
        object?.setObject(false, forKey: "done")
        object?.setObject(false, forKey: "expired")
        //object?.setObject("テスト", forKey: "label")
        
        object?.saveInBackground({ (error) in
            if error != nil{
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
            }
            else{
                self.navigationController?.popViewController(animated: true)
            }
        })
    }

    
    
}

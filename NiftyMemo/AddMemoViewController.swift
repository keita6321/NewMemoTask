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

class AddMemoViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet var textDatePicker: UITextField!
    let datePicker = UIDatePicker()
    
    @IBOutlet var memoTextView: UITextView!
    
    
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
        textDatePicker.inputView = datePicker
    }
    
    func donedatePicker(){
        //For date formate
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        textDatePicker.text = formatter.string(from: datePicker.date)
        //dismiss date picker dialog
        self.view.endEditing(true)
    }
    
    func cancelDatePicker(){
        //cancel button dismiss datepicker dialog
        self.view.endEditing(true)
    }
    
    //------------------------------
    
    @IBAction func save(){
    let object = NCMBObject(className: "NiftyMemo")
        object?.setObject(memoTextView.text, forKey: "text")
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
    }

}

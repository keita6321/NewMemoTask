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

class DetailViewController: UIViewController {

    @IBOutlet var textDatePicker: UITextField!
    let datePicker = UIDatePicker()

    @IBOutlet var memoTextView: UITextView!
    var selectedMemo: NCMBObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        memoTextView.text = selectedMemo.object(forKey: "text") as! String
        //textDatePicker.text = format(date: selectedMemo.object(forKey: "limit") as! Date)
        showDatePicker()
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
        formatter.dateFormat = "yyyy-MM-dd"
        textDatePicker.text = formatter.string(from: datePicker.date)
        //dismiss date picker dialog
        self.view.endEditing(true)
    }
    
    func cancelDatePicker(){
        //cancel button dismiss datepicker dialog
        self.view.endEditing(true)
    }
    
    func format(date:Date)->String{
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd"
        let strDate = dateformatter.string(from: date)
        
        return strDate
    }
    
    //------------------------------

    
    //メモの内容を変更
    @IBAction func update(){
        selectedMemo.setObject(memoTextView.text, forKey: "text")
        selectedMemo.setObject(textDatePicker.text, forKey: "limit")

        selectedMemo.saveInBackground { (error) in
            if error != nil{
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
            }
            else{
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

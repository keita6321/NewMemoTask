//
//  SelectTaskTypeViewController.swift
//  NiftyMemo
//
//  Created by nttr on 2017/09/12.
//  Copyright © 2017年 nttr. All rights reserved.
//

import UIKit

class LeftTaskViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func all() {
        self.slideMenuController()?.closeLeft()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.selectedType = 0
    }
    
    @IBAction func expired() {
        self.slideMenuController()?.closeLeft()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.selectedType = 1
    }
    
    @IBAction func today() {
        self.slideMenuController()?.closeLeft()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.selectedType = 2
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  SlideViewController.swift
//  testSlideMenu
//
//  Created by nttr on 2017/09/22.
//  Copyright © 2017年 nttr. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class SlideTodayTaskViewController: SlideMenuController {
    
    override func awakeFromNib() {
        let mainVC = storyboard?.instantiateViewController(withIdentifier: "TodayTask")
        let leftVC = storyboard?.instantiateViewController(withIdentifier: "LeftTask")
        var ud = UserDefaults.standard
        //UIViewControllerにはNavigationBarは無いためUINavigationControllerを生成しています。
        let navigationController = UINavigationController(rootViewController: mainVC!)
        //ライブラリ特有のプロパティにセット
        mainViewController = navigationController
        leftViewController = leftVC
        SlideMenuOptions.leftViewWidth.subtract(100)
        ud.set(SlideMenuOptions.leftViewWidth, forKey: "LW")
        print(SlideMenuOptions.leftViewWidth)
        super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

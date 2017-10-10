//
//  SelectTaskTypeViewController.swift
//  NiftyMemo
//
//  Created by nttr on 2017/09/12.
//  Copyright © 2017年 nttr. All rights reserved.
//

import UIKit
import NCMB


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
        postNotification(appDelegate: appDelegate)
    }
    
    @IBAction func expired() {
        self.slideMenuController()?.closeLeft()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.selectedType = 1
        postNotification(appDelegate: appDelegate)
    }
    
    @IBAction func today() {
        self.slideMenuController()?.closeLeft()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.selectedType = 2
        postNotification(appDelegate: appDelegate)
    }
    
    func postNotification(appDelegate: AppDelegate) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "taskType"), object: nil, userInfo: ["selectedType": appDelegate.selectedType])
    }

/*    func loadAllMemo2(){
        let query = NCMBQuery(className: "NiftyMemo")
        var allTaskArray = [NCMBObject]()
        //DBから全件データ呼び出し
        query?.findObjectsInBackground({ (result, error) in
            if error != nil{
                //SVProgressHUD.showError(withStatus: error?.localizedDescription)
            }
            if result?.count == 0{
                print("空や")
            }
            else{
                //全件データをDB更新用インスタンスのdataに退避
                print("全部で\(result?.count)件")
                var data = result as! [NCMBObject]
                let calendar = Calendar.current
                let now = Date()
                //完了済みタスクなら処理対象外とする
                for i in 0...(result?.count)!-1 {
                    if(data[i].object(forKey: "done") as! Bool){
                        data[i].setObject(false, forKey: "expired")
                        data[i].setObject(false, forKey: "today")
                    }
                        //完了済みじゃないタスクは以下の処理
                    else{
                        //dataにLimit情報を付与
                        var date = data[i].object(forKey: "limit") as! Date//Date型
                        if(now < date){
                            print("まだおk")
                            data[i].setObject(false, forKey: "expired")
                            data[i].setObject(false, forKey: "today")
                        }
                        else{
                            print("期限切れです")
                            data[i].setObject(true, forKey: "today")
                            data[i].setObject(true, forKey: "expired")
                        }
                        if(calendar.component(.day, from: now)==calendar.component(.day, from: date)){
                            print("今日まで")
                            data[i].setObject(true, forKey: "today")
                        }
                    }
                    if(!(data[i].object(forKey: "done")as! Bool)){
                        allTaskArray.append(data[i])
                    }
                    //DBはここでは更新されない
                    //ここで書いているのはupdateが成功または失敗する際の処理
                    data[i].saveInBackground({ (error) in
                        if(error != nil){
                            //SVProgressHUD.showError(withStatus: error?.localizedDescription)
                        }
                        else{
                            //print("limit saved"+String(i))
                        }
                    })
                    
                }
                //表示用配列の更新
                self.memoArray = allTaskArray
                self.memoTableView.reloadData()//こちらで扱うmemoArrayに格納
                
                print("update all")
            }
        })
    }
    
    func loadExpiredMemo2(){
        let query = NCMBQuery(className: "NiftyMemo")
        var todayMemoArray = [NCMBObject]()
        //DBから全件データ呼び出し
        query?.findObjectsInBackground({ (result, error) in
            if error != nil{
                //SVProgressHUD.showError(withStatus: error?.localizedDescription)
            }
            if result?.count == 0{
                print("空や")
            }
            else{
                print("全部で\(result?.count)件")
                var data = result as! [NCMBObject]
                let calendar = Calendar.current
                let now = Date()
                //完了済みなら処理対象外
                for i in 0...(result?.count)!-1 {
                    if(data[i].object(forKey: "done") as! Bool){
                        data[i].setObject(false, forKey: "expired")
                        data[i].setObject(false, forKey: "today")
                    }
                        //完了済みじゃないタスクは以下の処理
                    else{
                        //update用インスタンスにlimit情報を付与
                        var date = data[i].object(forKey: "limit") as! Date//Date型
                        if(now < date){
                            print("まだおk")
                            data[i].setObject(false, forKey: "expired")
                            data[i].setObject(false, forKey: "today")
                        }
                        else{
                            print("期限切れです")
                            data[i].setObject(true, forKey: "today")
                            data[i].setObject(true, forKey: "expired")
                        }
                        if(calendar.component(.day, from: now)==calendar.component(.day, from: date)){
                            print("今日まで")
                            data[i].setObject(true, forKey: "today")
                        }
                    }
                    //expiredフラグがtrueのものだけ収集
                    if(data[i].object(forKey: "expired")as! Bool){
                        todayMemoArray.append(data[i])
                    }
                    
                    //DBをdataでupdate
                    data[i].saveInBackground({ (error) in
                        if(error != nil){
                            //SVProgressHUD.showError(withStatus: error?.localizedDescription)
                        }
                        else{
                            print("DB更新完了")
                        }
                    })
                }
                self.memoArray = todayMemoArray
                self.memoTableView.reloadData()//こちらで扱うmemoArrayに格納
                print("update expired")
            }
        })
    }
    
    func loadTodayMemo2(){
        let query = NCMBQuery(className: "NiftyMemo")
        var todayMemoArray = [NCMBObject]()
        //DBから全件データ呼び出し
        query?.findObjectsInBackground({ (result, error) in
            if error != nil{
                //SVProgressHUD.showError(withStatus: error?.localizedDescription)
            }
            if result?.count == 0{
                print("空や")
            }
            else{
                print("全部で\(result?.count)件")
                var data = result as! [NCMBObject]
                let calendar = Calendar.current
                let now = Date()
                //完了済みなら処理対象外
                for i in 0...(result?.count)!-1 {
                    if(data[i].object(forKey: "done") as! Bool){
                        data[i].setObject(false, forKey: "expired")
                        data[i].setObject(false, forKey: "today")
                    }
                        //完了済みじゃないタスクは以下の処理
                    else{
                        //update用インスタンスにlimit情報を付与
                        var date = data[i].object(forKey: "limit") as! Date//Date型
                        if(now < date){
                            print("まだおk")
                            data[i].setObject(false, forKey: "expired")
                            data[i].setObject(false, forKey: "today")
                        }
                        else{
                            print("期限切れです")
                            data[i].setObject(true, forKey: "today")
                            data[i].setObject(true, forKey: "expired")
                        }
                        if(calendar.component(.day, from: now)==calendar.component(.day, from: date)){
                            print("今日まで")
                            data[i].setObject(true, forKey: "today")
                        }
                    }
                    //todayフラグがtrueのものだけ収集
                    if(data[i].object(forKey: "today")as! Bool){
                        todayMemoArray.append(data[i])
                    }
                    
                    //DBをdataでupdate
                    data[i].saveInBackground({ (error) in
                        if(error != nil){
                            //SVProgressHUD.showError(withStatus: error?.localizedDescription)
                        }
                        else{
                            print("DB更新完了")
                        }
                    })
                }
                self.memoArray = todayMemoArray
                self.memoTableView.reloadData()//こちらで扱うmemoArrayに格納
                print("update today")
            }
        })
    }*/
    
}

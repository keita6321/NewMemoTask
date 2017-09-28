//
//  ListViewController.swift
//  NiftyMemo
//
//  Created by nttr on 2017/08/23.
//  Copyright © 2017年 nttr. All rights reserved.
//

import UIKit
import NCMB
import SVProgressHUD
import UserNotifications

class ListViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    //var myAppDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet var memoTableView: UITableView!
    var memoArray = [NCMBObject]()
    var memoListBackImage = UIImage(named: "gplaypattern_@2X.png")!
    var imageView: UIImageView!
    //var ud = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memoTableView.dataSource = self
        memoTableView.delegate = self
        memoTableView.tableFooterView = UIView()
        loadMemo()
        
        
        //requestAuth()
    }
    override func viewWillAppear(_ animated: Bool) {
        loadMemo()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //メモの個数を返す
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoArray.count
    }
    //セルを返す
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = memoArray[indexPath.row].object(forKey: "text") as! String
        return cell
    }
    //選択したセルを認識
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toDetail", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)//選択を解除される
    }
    //値渡し
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail"{
            let detailViewController = segue.destination as! DetailViewController
            let selectedIndex = memoTableView.indexPathForSelectedRow!
            detailViewController.selectedMemo = memoArray[selectedIndex.row]
        }
    }
    
    //スワイプでセルの削除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //選択しているセルの削除
        print(memoArray.count)
        print(indexPath.row)
        if editingStyle == .delete {
            //tableViewのセルが削除される
            let query = NCMBQuery(className: "NiftyMemo")
            query?.whereKey("objectId", equalTo: memoArray[indexPath.row].object(forKey: "objectId"))
            query?.findObjectsInBackground({ (result, error) in
                if error != nil{
                    SVProgressHUD.showError(withStatus: error?.localizedDescription)
                }
                else{
                    print (type(of: result))
                    let memo = result as! [NCMBObject]
                    let textObject = memo.first//一つしかないしfirstでいい
                    textObject?.deleteInBackground({ (error) in
                        if error != nil{
                            SVProgressHUD.showError(withStatus: error?.localizedDescription)
                        }
                        else{
                            print("delete sucsess")
                        }
                    })
                }
            })
            memoArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        print(memoArray.count)
    }
    //自動振り分け
    //全タスクの完了・遅延・今日やるフラグを一元管理
    func checkLimit(){
        let query = NCMBQuery(className: "NiftyMemo")
        
        query?.findObjectsInBackground({ (result, error) in
            if error != nil{
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
            }
            if result?.count == 0{
                print("空や")
            }
            else{//本題
                var data = result as! [NCMBObject]
                let calendar = Calendar.current
                let d = Date()
                let str2: [String] = [String(calendar.component(.year, from: d)),String(calendar.component(.month, from: d)),String(calendar.component(.day, from: d))]
                var split = str2//今日の日付
                print(split[0],split[1],split[2])
                
                for i in 0...(result?.count)!-1 {//完了済みか否か最初に判断する
                    //if(data[i].object(forKey: "limit")as! String == "期限を設定"){
                    //    continue
                    //}
                    //else{
                    if(data[i].object(forKey: "done") as! Bool){
                        //print(i)
                        data[i].setObject(false, forKey: "expired")
                        data[i].setObject(false, forKey: "today")
                        //print("完了済み")
                    }
                    else{//月の判定
                        var date = data[i].object(forKey: "limit") as! String
                        var date_split = date.components(separatedBy: "-")
                        if("\(date_split[1].substring(to: date_split[1].index(after: date_split[1].startIndex)))" == "0"){
                            date_split[1] = "\(date_split[1].substring(from: date_split[1].index(before: date_split[1].endIndex)))"
                        }
                        
                        if(Int(date_split[1])! < Int(split[1])!){//月が過ぎてる
                            //print(i)
                            //print("もう月変わっちゃってますよ")
                            data[i].setObject(true, forKey: "expired")
                            data[i].setObject(true, forKey: "today")
                        }
                        else if(Int(date_split[1])! > Int(split[1])!){//翌月以降
                            //print(i)
                            //print("まだまだ時間はある")
                            //print(date_split[1])
                            data[i].setObject(false, forKey: "expired")
                            data[i].setObject(false, forKey: "today")
                        }
                        else{//日付で判定
                            if("\(date_split[2].substring(to: date_split[2].index(after: date_split[2].startIndex)))" == "0"){
                                date_split[2] = "\(date_split[2].substring(from: date_split[2].index(before: date_split[2].endIndex)))"
                            }
                            if(Int(date_split[2])! < Int(split[2])!){//31日＞30日
                                //print(i)
                                //print("締め切り過ぎてますが")
                                data[i].setObject(true, forKey: "expired")
                                data[i].setObject(true, forKey: "today")
                            }
                            else if(Int(date_split[2])! > Int(split[2])!){
                                //print(i)
                                //print("早めに進めましょう")
                                data[i].setObject(false, forKey: "expired")
                                data[i].setObject(false, forKey: "today")
                            }
                            else{
                                //print(i)
                                //print("今日までですよー")
                                data[i].setObject(false, forKey: "expired")
                                data[i].setObject(true, forKey: "today")
                            }
                        }
                        //}
                    }
                    data[i].saveInBackground({ (error) in
                        //print(i)
                        if(error != nil){
                            SVProgressHUD.showError(withStatus: error?.localizedDescription)
                        }
                        else{
                            //print("limit saved"+String(i))
                        }
                    })
                }
            }
        })
    }
    //AllTask画面が呼び出されるたびに必ず実行される期限チェック関数
    func checkLimit2(){
        let query = NCMBQuery(className: "NiftyMemo")
        
        query?.findObjectsInBackground({ (result, error) in
            if error != nil{
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
            }
            if result?.count == 0{
                print("空や")
            }
            else{//本題
                var data = result as! [NCMBObject]
                let calendar = Calendar.current
                let now = Date()
                
                for i in 0...(result?.count)!-1 {//完了済みなら処理対象外
                    if(data[i].object(forKey: "done") as! Bool){
                        data[i].setObject(false, forKey: "expired")
                        data[i].setObject(false, forKey: "today")
                    }
                    else{
                        var date = data[i].object(forKey: "limit") as! Date//Date型
                        //let b = Calendar.current
                        //let c = calendar.date(byAdding: .minute, value: 1, to: Date())!
                        
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
                    data[i].saveInBackground({ (error) in
                        if(error != nil){
                            SVProgressHUD.showError(withStatus: error?.localizedDescription)
                        }
                        else{
                            //print("limit saved"+String(i))
                        }
                    })
                }
            }
        })
    }
    
    
    
    //DBの更新とtableViewへの反映
    func loadMemo(){
        let query = NCMBQuery(className: "NiftyMemo")
        query?.findObjectsInBackground({ (result, error) in
            if error != nil{
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
            }
            else{
                self.memoArray = result as! [NCMBObject]//DBから全件取得して
                self.memoTableView.reloadData()//こちらで扱うmemoArrayに格納
                self.checkLimit2()
            }
        })
    }
    
}

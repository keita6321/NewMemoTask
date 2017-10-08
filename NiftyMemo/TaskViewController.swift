//
//  ListViewController.swift
//  NiftyMemo
//
//  Created by nttr on 2017/08/23.
//  Copyright © 2017年 nttr. All rights reserved.
//

import UIKit
import NCMB

import SlideMenuControllerSwift
import UserNotifications

class TaskViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, SlideMenuControllerDelegate {
    
    @IBOutlet var label: UILabel!
    
    //var myAppDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet var memoTableView: UITableView!
    var memoArray = [NCMBObject]()
    var memoListBackImage = UIImage(named: "gplaypattern_@2X.png")!
    var imageView: UIImageView!
    private var cellHeightList: [IndexPath: CGFloat] = [:]
    //var ud = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memoTableView.dataSource = self
        memoTableView.delegate = self
        memoTableView.tableFooterView = UIView()
        let nib = UINib(nibName: "TaskTableViewCell", bundle: Bundle.main)
        memoTableView.register(nib, forCellReuseIdentifier: "TaskCell")
        memoTableView.estimatedRowHeight = 67
        memoTableView.rowHeight = UITableViewAutomaticDimension
        
        loadAllMemo2()
        self.slideMenuController()?.delegate = self
        
        //requestAuth()
    }
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if(appDelegate.selectedType == 0){
            loadAllMemo2()
        }
        if(appDelegate.selectedType == 1){
            loadExpiredMemo2()
        }
        
        if(appDelegate.selectedType == 2){
            loadTodayMemo2()
            title?.removeAll()
        }
    }
    
    func leftDidClose() {
        //all=0, expired=1, today=2
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        print("slectedType \(appDelegate.selectedType)")
        if(appDelegate.selectedType == 0){
            loadAllMemo2()
        }
        if(appDelegate.selectedType == 1){
            loadExpiredMemo2()
        }
        
        if(appDelegate.selectedType == 2){
            loadTodayMemo2()
            title?.removeAll()
        }
        
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
        //let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell") as! TaskTableViewCell
        //cell.textLabel?.text = memoArray[indexPath.row].object(forKey: "text") as! String
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY/MM/dd"
        
        cell.mainLabel.text = memoArray[indexPath.row].object(forKey: "text") as! String
        cell.dateLabel.text = formatter.string(from: memoArray[indexPath.row].object(forKey: "limit") as! Date)
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
            let detailViewController = segue.destination as! DetailTaskViewController
            let selectedIndex = memoTableView.indexPathForSelectedRow!
            //ncmbObjectごと投げる
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
                    //SVProgressHUD.showError(withStatus: error?.localizedDescription)
                }
                else{
                    print (type(of: result))
                    let memo = result as! [NCMBObject]
                    let textObject = memo.first//一つしかないしfirstでいい
                    textObject?.deleteInBackground({ (error) in
                        if error != nil{
                            //SVProgressHUD.showError(withStatus: error?.localizedDescription)
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
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if let height = self.cellHeightList[indexPath] {
            return height
        }
        else {
            return tableView.estimatedRowHeight
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !self.cellHeightList.keys.contains(indexPath) {
            self.cellHeightList[indexPath] = cell.frame.size.height
        }
    }
    
    
    //自動振り分け
    //全タスクの完了・遅延・今日やるフラグを一元管理
    func checkLimit(){
        let query = NCMBQuery(className: "NiftyMemo")
        query?.findObjectsInBackground({ (result, error) in
            if error != nil{
                //SVProgressHUD.showError(withStatus: error?.localizedDescription)
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
                            //SVProgressHUD.showError(withStatus: error?.localizedDescription)
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
                //SVProgressHUD.showError(withStatus: error?.localizedDescription)
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
                            //SVProgressHUD.showError(withStatus: error?.localizedDescription)
                        }
                        else{
                            //print("limit saved"+String(i))
                        }
                    })
                }
            }
        })
    }
    
    
    func updateLimitFlags(){
        let query = NCMBQuery(className: "NiftyMemo")
        //DBのデータ呼び出し
        query?.findObjectsInBackground({ (result, error) in
            if error != nil{
                //SVProgressHUD.showError(withStatus: error?.localizedDescription)
            }
            else{
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
                            //SVProgressHUD.showError(withStatus: error?.localizedDescription)
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
    func loadAllMemo(){
        let query = NCMBQuery(className: "NiftyMemo")
        var allTaskArray = [NCMBObject]()
        
        //DBのデータ呼び出し
        query?.findObjectsInBackground({ (result, error) in
            if error != nil{
                //SVProgressHUD.showError(withStatus: error?.localizedDescription)
            }
            else{
                //self.updateLimitFlags()
                self.memoArray = result as! [NCMBObject]//DBから全件取得して
                self.memoTableView.reloadData()//こちらで扱うmemoArrayに格納
                self.checkLimit()
                print("見た目更新完了")
            }
        })
    }
    
    //DB呼び出しからのLimit更新からの表示も更新
    func loadAllMemo2(){
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
    }
    
    
}


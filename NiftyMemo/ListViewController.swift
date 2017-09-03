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

class ListViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet var memoTableView: UITableView!
    var memoArray = [NCMBObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memoTableView.dataSource = self
        memoTableView.delegate = self
        memoTableView.tableFooterView = UIView()
        //showDatePicker()
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
    
    func checkLimit(){
        let query = NCMBQuery(className: "NiftyMemo")
        //var i = 0
        
        query?.findObjectsInBackground({ (result, error) in
            //print(result?.count)
            if error != nil{
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
            }
            if result?.count == 0{
                print("空や")
            }
            else{
                var data = result as! [NCMBObject]
                for i in 0...(result?.count)!-1{
                    var date = data[i].object(forKey: "limit") as! String
                    var date_split = date.components(separatedBy: "-")
                    let str = "2017-08-30"
                    let split = str.components(separatedBy: "-")
                    
                    if(date_split[1] > split[1]){//7月＞8月
                        print(i)
                        print("月変わっちゃってますよ")
                        data[i].setObject(true, forKey: "expired")
                    }
                    else if(date_split[1] < split[1]){
                        print(i)
                        print("まだまだ時間はある")
                    }
                    else{//月は同じ
                        //if(date_split[2].substring(to: date_split[2].startIndex) == "0"){
                        //    date_split[2] = date_split[2].substring(from: date_split[2].endIndex)
                        //}
                        if(date_split[2] > split[2]){//31日＞30日
                            print(i)
                            print("締め切り過ぎてますが")
                            data[i].setObject(true, forKey: "expired")
                        }
                        if(date_split[2] < split[2]){
                            print(i)
                            print("早めに進めましょう")
                        }
                        else{
                            print(i)
                            print("今日までですよー")
                            data[i].setObject(true, forKey: "today")
                        }
                    }
                    data[i].saveInBackground({ (error) in
                        print(i)
                        if(error != nil){
                            SVProgressHUD.showError(withStatus: error?.localizedDescription)
                        }
                        else{
                            print("ok"+String(i))
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
                self.checkLimit()
            }
        })
    }
}

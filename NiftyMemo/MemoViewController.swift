//
//  MemoViewController.swift
//  NiftyMemo
//
//  Created by nttr on 2017/09/12.
//  Copyright © 2017年 nttr. All rights reserved.
//

import UIKit
import NCMB
import SVProgressHUD

class MemoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var memoTableView: UITableView!
    var memoArray = [NCMBObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memoTableView.delegate = self
        memoTableView.dataSource = self
        // カスタムセルの登録
        let nib = UINib(nibName: "SampleTableViewCell", bundle: Bundle.main)
        memoTableView.register(nib, forCellReuseIdentifier: "SampleCell")
        
        //print("タブバーの高さ")
        //print(tabBarController?.tabBar.frame.height)
        //print("なびばーの高さ")
        //print((navigationController?.navigationBar.frame.height)!)
        memoTableView.tableFooterView = UIView()
        loadMemo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        loadMemo()
    }
    
    //メモの個数を返す
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoArray.count
    }
    //セルを返す
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SampleCell")!
        cell.textLabel?.text = memoArray[indexPath.row].object(forKey: "text") as! String
        
        cell.textLabel?.font = UIFont(name: "HarenosoraMincho", size: 17)
        
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
            let detailMemoViewController = segue.destination as! DetailMemoViewController
            let selectedIndex = memoTableView.indexPathForSelectedRow!
            detailMemoViewController.selectedMemo = memoArray[selectedIndex.row]
            //ncmbObjectごと投げる
            
            //DetailMemoViewController.sele = memoArray[selectedIndex.row]
        }
    }
    
    //スワイプ削除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //選択しているセルの削除
        print(memoArray.count)
        print(indexPath.row)
        if editingStyle == .delete {
            //tableViewのセルが削除される
            let query = NCMBQuery(className: "Memo")
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

    

    func loadMemo(){
        let query = NCMBQuery(className: "Memo")
        query?.findObjectsInBackground({ (result, error) in
            if error != nil{
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
            }
            else{
                self.memoArray = result as! [NCMBObject]//DBから全件取得して
                self.memoTableView.reloadData()//こちらで扱うmemoArrayに格納
            }
        })
    }

}

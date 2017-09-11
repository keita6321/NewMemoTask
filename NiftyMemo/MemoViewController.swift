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

class MemoViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var memoTableView: UITableView!
    var memoArray = [NCMBObject]()
    var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memoTableView.dataSource = self
        memoTableView.delegate = self
        memoTableView.tableFooterView = UIView()
    }
    override func viewWillAppear(_ animated: Bool) {
        //loadMemo()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemoCell")!
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
                //self.checkLimit()
            }
        })
    }
    
}

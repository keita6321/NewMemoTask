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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = memoArray[indexPath.row].object(forKey: "text") as! String
        return cell
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

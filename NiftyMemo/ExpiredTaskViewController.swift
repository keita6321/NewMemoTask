//
//  ExpiredTaskViewController.swift
//  NiftyMemo
//
//  Created by nttr on 2017/09/12.
//  Copyright © 2017年 nttr. All rights reserved.
//

import UIKit
import SVProgressHUD
import NCMB

class ExpiredTaskViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var memoTableView: UITableView!
    var memoArray = [NCMBObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memoTableView.dataSource = self
        memoTableView.delegate = self
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        loadExpiredMemo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //メモの個数を返す
    //func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //    return memoArray.count
    //}
    //セルを返す
    //func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        // cell内のcontentViewの背景を透過
    //    cell.backgroundColor = UIColor.clear
    //    cell.contentView.backgroundColor = UIColor.clear
    //    cell.textLabel?.text = memoArray[indexPath.row].object(forKey: "text") as! String
    //    return cell
    //}
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = memoArray[indexPath.row].object(forKey: "text") as! String
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toDetail", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func loadExpiredMemo(){
        let query = NCMBQuery(className: "NiftyMemo")
        query?.whereKey("expired", equalTo: true)
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

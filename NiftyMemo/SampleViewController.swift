//
//  ViewController.swift
//  TableBgImageSample
//
//  Created by Masuhara on 2017/09/12.
//  Copyright © 2017年 Ylab, Inc. All rights reserved.
//

import UIKit

class SampleViewController: UIViewController, UITableViewDataSource {
    
    // データ
    var sampleData = ["dog", "cat", "bird"]
    
    // TableView
    @IBOutlet var sampleTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // データソースの設定
        sampleTableView.dataSource = self
        
        // カスタムセルの登録
        let nib = UINib(nibName: "SampleTableViewCell", bundle: Bundle.main)
        sampleTableView.register(nib, forCellReuseIdentifier: "SampleCell")
        
        // 余分な横線の削除
        sampleTableView.tableFooterView = UIView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - TableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sampleData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SampleCell") as! SampleTableViewCell
        cell.sampleLabel.text = sampleData[indexPath.row]
        return cell
    }
}


//
//  MemoListViewController.swift
//  CloudNotes
//
//  Created by sookim on 2021/06/15.
//

import UIKit

class MemoListViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
        self.tableView.register(MemoListCell.self, forCellReuseIdentifier: MemoListCell.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DataManager.shared.fetchData()
    }
    
    @objc func addNote() {
        DataManager.shared.createData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataManager.shared.memoList.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        splitViewController?.show(.secondary)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MemoListCell.identifier, for: indexPath) as! MemoListCell
        cell.setCellData(currentMemoData: DataManager.shared.memoList[indexPath.row])
        
        return cell
    }
}

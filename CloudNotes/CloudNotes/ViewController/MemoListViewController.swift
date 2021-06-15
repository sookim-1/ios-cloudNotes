//
//  MemoListViewController.swift
//  CloudNotes
//
//  Created by sookim on 2021/06/15.
//

import UIKit

class MemoListViewController: UITableViewController {
    
    var delegate: SendDataDelegate?
    
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
        delegate?.sendData(data: DataManager.shared.memoList[indexPath.row], index: indexPath.row)
        splitViewController?.show(.secondary)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MemoListCell.identifier, for: indexPath) as! MemoListCell
        cell.setCellData(currentMemoData: DataManager.shared.memoList[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { (action, view, completionHandler ) in
            
            let defaultAction = UIAlertAction(title: "삭제", style: .destructive) { (action) in
                DataManager.shared.deleteData(index: indexPath.row)
            }
            let cancelAction = UIAlertAction(title: "취소", style: .cancel)
            let alert = UIAlertController(title: "진짜요?", message: "정말로 삭제하시겠어요?", preferredStyle: .alert)
            alert.addAction(defaultAction)
            alert.addAction(cancelAction)

            self.present(alert, animated: true)
            completionHandler(true)
        }
        
        let shareAction = UIContextualAction(style: .normal, title: "공유") { (action, view, completionHandler ) in
            guard let sendText = DataManager.shared.memoList[indexPath.row].body else { return }
            
            let shareSheetViewController = UIActivityViewController(activityItems: [sendText], applicationActivities: nil)
        
            if let popOverController = shareSheetViewController.popoverPresentationController {
                popOverController.sourceView = view
            }
            
            self.present(shareSheetViewController, animated: true)
            completionHandler(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
    }
    
}

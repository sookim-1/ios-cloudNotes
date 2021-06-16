//
//  MemoListViewController.swift
//  CloudNotes
//
//  Created by sookim on 2021/06/15.
//

import UIKit
import CoreData

class MemoListViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var delegate: SendDataDelegate?
    let dataControl = DataManager.shared
    
    lazy var fetchResultController : NSFetchedResultsController<Memo> = {

        let fetchRequest : NSFetchRequest<Memo> = Memo.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lastModifiedDate", ascending: false)]
        let fetchResult = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataControl.mainContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchResult.delegate = self
        return fetchResult
            
     }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataControl.saveContext()
        do{
            try fetchResultController.performFetch()
            print("fetch finish")

        }
        catch let err{
            print("Freind Fetch Error" , err.localizedDescription)
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
        self.tableView.register(MemoListCell.self, forCellReuseIdentifier: MemoListCell.identifier)
    }
    
    @objc func addNote() {
        let newMemo = Memo(context: dataControl.mainContext)
        newMemo.title = "새로운 메모"
        newMemo.body = "추가 텍스트 없음"
        newMemo.lastModifiedDate = Date()
        
        dataControl.saveContext()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchResultController.sections?[0].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let sendCell = fetchResultController.fetchedObjects else { return }
        
      //  delegate?.sendData(data: sendCell[indexPath.row], index: indexPath.row)
        
        splitViewController?.show(.secondary)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MemoListCell.identifier, for: indexPath) as! MemoListCell
        let data = fetchResultController.object(at: indexPath)
        cell.setCellData(currentMemoData: data)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { (action, view, completionHandler ) in
            
            let defaultAction = UIAlertAction(title: "삭제", style: .destructive) { (action) in
                let memoToRemove = self.fetchResultController.object(at: indexPath)
                self.dataControl.mainContext.delete(memoToRemove)
                self.dataControl.saveContext()
            }
            let cancelAction = UIAlertAction(title: "취소", style: .cancel)
            let alert = UIAlertController(title: "진짜요?", message: "정말로 삭제하시겠어요?", preferredStyle: .alert)
            alert.addAction(defaultAction)
            alert.addAction(cancelAction)

            self.present(alert, animated: true)
            completionHandler(true)
        }
        
        let shareAction = UIContextualAction(style: .normal, title: "공유") { (action, view, completionHandler ) in
            guard let sendText = self.fetchResultController.object(at: indexPath).body else { return }
            
            let shareSheetViewController = UIActivityViewController(activityItems: [sendText], applicationActivities: nil)
        
            if let popOverController = shareSheetViewController.popoverPresentationController {
                popOverController.sourceView = view
            }
            
            self.present(shareSheetViewController, animated: true)
            completionHandler(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
          tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
          tableView.deleteRows(at: [indexPath!], with: .automatic)
        default:
            print("에러")
        }
    }
}

extension MemoListViewController: SendDataDelegate {
    func sendData(data: String) {
   //     let data = fetchResultController.object(at: IndexPath())
        print("\(data) " )
    }
}

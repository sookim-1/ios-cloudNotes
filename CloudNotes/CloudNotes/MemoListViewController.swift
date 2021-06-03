//
//  MemoListViewController.swift
//  CloudNotes
//
//  Created by sookim on 2021/06/03.
//

import Foundation
import UIKit

class MemoListViewController: UIViewController {
    let myTableView = UITableView()
    let decoder = JSONDecoder()
    weak var delegate: ControllerDelegate?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.myTableView.dataSource = self
        self.myTableView.delegate = self
        
        self.myTableView.register(MemoListCell.self, forCellReuseIdentifier: MemoListCell.identifier)
        self.view.addSubview(self.myTableView)

        self.myTableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraint(NSLayoutConstraint(item: self.myTableView,
                                                   attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top,
                                                   multiplier: 1.0, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.myTableView,
                                                   attribute: .bottom, relatedBy: .equal, toItem: self.view,
                                                   attribute: .bottom, multiplier: 1.0, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.myTableView,
                                                   attribute: .leading, relatedBy: .equal, toItem: self.view,
                                                   attribute: .leading, multiplier: 1.0, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.myTableView,
                                                   attribute: .trailing, relatedBy: .equal, toItem: self.view,
                                                   attribute: .trailing, multiplier: 1.0, constant: 0))
    }
    
    func decodeMemoData() -> [MemoData]? {
        guard let data = NSDataAsset(name: "sample") else { return nil }
        
        do {
            let result = try decoder.decode([MemoData].self, from: data.data)
            let date = Date(timeIntervalSinceReferenceDate: result.first?.lastModified ?? 0)
            return result
        }
        catch {
            return nil
        }
    }
}

extension MemoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //navigationController?.pushViewController(DetailViewController(), animated: true)
        //self.navigationController?.pushToViewController(DetailViewController(), animated: true)
        //self.splitViewController?.showDetailViewController(DetailViewController(), sender: nil)
        let memoData = decodeMemoData()!
        //DetailViewController.receiveData = memoData[indexPath.row]
        //navigationController?.showDetailViewController(DetailViewController(), sender: sendData)
        //self.showDetailViewController(DetailViewController(), sender: self)
        //let cellLabel = tableView.cellForRow(at: indexPath)?.textLabel?.text
        
        myTableView.deselectRow(at: indexPath, animated: true)
        delegate?.didTapMenuItem(at: indexPath.row)
        //splitViewController?.show(DetailViewController(), sender: nil)
    }
}

extension MemoListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let memoData = decodeMemoData()!
        
        return memoData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MemoListCell.identifier, for: indexPath) as! MemoListCell

        let memoData = decodeMemoData()!
        cell.memoTitle.text = memoData[indexPath.row].title
        cell.memoDateCreate.text = memoData[indexPath.row].lastModifiedDate
        cell.memoPreview.text = memoData[indexPath.row].body
        
        return cell
    }
    
}

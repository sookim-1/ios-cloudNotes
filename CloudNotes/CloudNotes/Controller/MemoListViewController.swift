//
//  MemoListViewController.swift
//  CloudNotes
//
//  Created by sookim on 2021/06/03.
//

import UIKit

class MemoListViewController: UIViewController {
    
    private let tableView = UITableView()
    private let decoder = JSONDecoder()
    var memoData: [MemoData] = []
    var delegate: SendDataDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
        self.tableView.register(MemoListCell.self, forCellReuseIdentifier: MemoListCell.identifier)
        self.view.addSubview(self.tableView)
        setTableViewConstraint()
        decodeMemoData()
    }

    override func viewWillAppear(_ animated: Bool) {
        if splitViewController?.traitCollection.horizontalSizeClass == .regular {
            delegate?.isRegularTextViewColor(regular: true)
        }
    }
    
    @objc func addNote() {
        
    }
    
    private func setTableViewConstraint() {
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraint(NSLayoutConstraint(item: self.tableView,
                                                   attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top,
                                                   multiplier: 1.0, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.tableView,
                                                   attribute: .bottom, relatedBy: .equal, toItem: self.view,
                                                   attribute: .bottom, multiplier: 1.0, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.tableView,
                                                   attribute: .leading, relatedBy: .equal, toItem: self.view,
                                                   attribute: .leading, multiplier: 1.0, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.tableView,
                                                   attribute: .trailing, relatedBy: .equal, toItem: self.view,
                                                   attribute: .trailing, multiplier: 1.0, constant: 0))
    }
    
    func decodeMemoData() {
        guard let data = NSDataAsset(name: "sample") else { return }
        
        do {
            self.memoData = try decoder.decode([MemoData].self, from: data.data)
        }
        catch {
            return
        }
    }
    
}

extension MemoListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.sendData(data: memoData[indexPath.row])
        
        guard let memoDetailViewController = delegate as? DetailViewController else { return }
        
        if UITraitCollection.current.horizontalSizeClass == .compact {
            splitViewController?.showDetailViewController(UINavigationController(rootViewController: memoDetailViewController) , sender: nil)
        }
    }
    
}

extension MemoListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MemoListCell.identifier, for: indexPath) as! MemoListCell
        let currentMemoData = memoData[indexPath.row]
        
        cell.setCellData(title: currentMemoData.title, body: currentMemoData.body, dateCreate: currentMemoData.lastModifiedDate)

        return cell
    }
    
}

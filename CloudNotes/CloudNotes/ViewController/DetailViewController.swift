//
//  DetailViewController.swift
//  CloudNotes
//
//  Created by sookim on 2021/06/15.
//

import UIKit

class DetailViewController: UIViewController, SendDataDelegate {
    var memoDetailTextView: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor.black
        view.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(editMemo))
        self.view.addSubview(memoDetailTextView)
        setTextViewConstraint()
    }
    
    @objc func editMemo() {
    }
    
    private func setTextViewConstraint() {
        self.memoDetailTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        self.memoDetailTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        self.memoDetailTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        self.memoDetailTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
    }
    
    func sendData(data: Memo, index: Int) {
        self.memoDetailTextView.text = "\(data.title!) + \(data.body!) + \(index)"
    }
    
}

//
//  DetailViewController.swift
//  CloudNotes
//
//  Created by sookim on 2021/06/03.
//

import Foundation
import UIKit

class DetailViewController: UIViewController, ControllerDelegate {
   // let textView = UITextView()
    let textView = UITextView(frame: CGRect(x: 20.0, y: 90.0, width: 250.0, height: 100.0))
   
    override func viewDidLoad() {
        super.viewDidLoad()
            
        
        textView.contentInsetAdjustmentBehavior = .automatic
        textView.center = self.view.center
        textView.textAlignment = NSTextAlignment.justified
        textView.textColor = UIColor.blue
        textView.backgroundColor = UIColor.red
        textView.text = "fennfoenon"
        self.view.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false

        textView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        textView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        textView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        textView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
    }
    
    func decodeMemoData() -> [MemoData]? {
        let decoder = JSONDecoder()
        
        guard let data = NSDataAsset(name: "sample") else { return nil }
        
        do {
            let result = try decoder.decode([MemoData].self, from: data.data)
            return result
        }
        catch {
            return nil
        }
    }
    
    func didTapMenuItem(at index: Int) {
        (splitViewController?.viewControllers.last as? UINavigationController)?.popToRootViewController(animated: true)
        let memoData = decodeMemoData()!
        textView.text = memoData[index].body
                
        (splitViewController?.viewControllers.last as? UINavigationController)?.pushViewController(MemoListViewController(), animated: true)
    }
}

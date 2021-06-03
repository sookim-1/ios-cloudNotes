//
//  MemoSplitViewController.swift
//  CloudNotes
//
//  Created by sookim on 2021/06/03.
//

import Foundation
import UIKit

class MemoSplitViewController: UISplitViewController, UISplitViewControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        let memoListView = MemoListViewController()
        let detailView = DetailViewController()
        
        memoListView.title = "메모"
        memoListView.delegate = detailView
        let memoListViewController = UINavigationController(rootViewController: memoListView)
        let detailViewController = UINavigationController(rootViewController: detailView)
        self.preferredDisplayMode = .oneBesideSecondary
        self.viewControllers = [memoListViewController, detailViewController]
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
}

//
//  MemoSplitViewController.swift
//  CloudNotes
//
//  Created by sookim on 2021/06/15.
//

import UIKit

class MemoSplitViewController: UISplitViewController, UISplitViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        setSplitView()
    }
    
    private func setSplitView() {
        let memoListViewController = MemoListViewController()
        let detailViewController = DetailViewController()
        memoListViewController.title = "메모"
        memoListViewController.delegate = detailViewController
        self.setViewController(memoListViewController, for: .primary)
        self.setViewController(detailViewController, for: .secondary)
        self.preferredDisplayMode = .oneBesideSecondary
        self.preferredSplitBehavior = .tile
    }
    
    func splitViewController(_ svc: UISplitViewController, topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
        return .primary
    }
}

//
//  ViewController.swift
//  TableViewSwipeAction
//
//  Created by Rajat Bhatt on 12/09/17.
//  Copyright © 2017 Rajat Bhatt. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var panGesturedCell: SwipeTableViewCell?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "TEST"
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SwipeTableViewCell
        cell.delegate = self as TableViewCellDelegate
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! SwipeTableViewCell
        cell.leftSwipeCount = 0
        cell.leadingConstraintTopViewOutlet.constant = -8
        cell.trailingConstraintActionViewOutlet.constant = -122
        UIView.animate(withDuration: 0.5, animations: {
            cell.layoutIfNeeded()
        })
    }
}

extension MainViewController: TableViewCellDelegate {
    func hasPerformedSwipe(passedInfo: String, cell: SwipeTableViewCell) {
        print(passedInfo)
        if panGesturedCell == nil {
            panGesturedCell = cell
        } else {
            panGesturedCell?.leftSwipeCount = 0
            panGesturedCell?.leadingConstraintTopViewOutlet.constant = -8
            panGesturedCell?.trailingConstraintActionViewOutlet.constant = -122
            UIView.animate(withDuration: 0.5, animations: {
                cell.layoutIfNeeded()
            })
            panGesturedCell = cell
        }
    }
}

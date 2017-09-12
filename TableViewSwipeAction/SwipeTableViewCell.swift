//
//  SwipeTableViewCell.swift
//  TableViewSwipeAction
//
//  Created by Rajat Bhatt on 12/09/17.
//  Copyright © 2017 Rajat Bhatt. All rights reserved.
//

import UIKit

protocol TableViewCellDelegate {
    func hasPerformedSwipe(passedInfo: String)
}

class SwipeTableViewCell: UITableViewCell {
    var delegate: TableViewCellDelegate?
    var originalCenter = CGPoint()
    var isSwipeSuccessful = false
    var isSwipeLeft = false
    var buttonViewOriginalCenter = CGPoint()
    var leftSwipeCount = 0
    
    @IBOutlet weak var buttonViewOutlet: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var trailingConstraintActionViewOutlet: NSLayoutConstraint!
    @IBOutlet weak var leadingConstraintContainerViewOutlet: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initialize()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initialize() {
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(recognizer:)))
        recognizer.delegate = self
        containerView.addGestureRecognizer(recognizer)
        buttonViewOriginalCenter = buttonViewOutlet.center
        trailingConstraintActionViewOutlet.constant = -120
    }
    func handlePan(recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .began {
            originalCenter = containerView.center
        }
        
        if recognizer.state == .changed {
            checkIfSwiped(recognizer: recognizer)
        }
        
        if recognizer.state == .ended {
            //let originalFrame = CGRect(x: 0, y: containerView.frame.origin.y, width: containerView.bounds.size.width, height: containerView.bounds.size.height)
            if isSwipeSuccessful, let delegate = self.delegate {
                leftSwipeCount += 1
                delegate.hasPerformedSwipe(passedInfo: "I performed a swipe")
                //moveViewBackIntoPlace(originalFrame: originalFrame)
                self.trailingConstraintActionViewOutlet.constant = 0
                self.leadingConstraintContainerViewOutlet.constant = -128
                UIView.animate(withDuration: 0.3, animations: {
                    self.layoutIfNeeded()
                })
            } else {
                leftSwipeCount = 0
                self.trailingConstraintActionViewOutlet.constant = -120
                self.leadingConstraintContainerViewOutlet.constant = -8
                UIView.animate(withDuration: 0.5, animations: {
                    self.layoutIfNeeded()
                })
            }
        }
        
    }
    func checkIfSwiped(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.containerView)
        isSwipeSuccessful = recognizer.isLeft(theViewYouArePassing: self.containerView)
        if isSwipeSuccessful {
            if leftSwipeCount == 0 {
                self.containerView.center = CGPoint(x: originalCenter.x + translation.x, y: originalCenter.y)
            }
        }
        print(isSwipeSuccessful)
    }
    func moveViewBackIntoPlace(originalFrame: CGRect) {
        UIView.animate(withDuration: 0.2, animations: {self.containerView.frame = originalFrame})
    }
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGestureRecognizer.translation(in: superview!)
            if fabs(translation.x) > fabs(translation.y) {
                return true
            }
        }
        return false
    }
}

extension UIPanGestureRecognizer {
    func isLeft(theViewYouArePassing: UIView) -> Bool {
        let viewVelocity : CGPoint = velocity(in: theViewYouArePassing)
        if viewVelocity.x > 0 {
            print("Gesture went right")
            return false
        } else {
            print("Gesture went left")
            return true
        }
    }
}

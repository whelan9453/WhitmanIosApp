//
//  ChatViewController.swift
//  Whitman2017
//
//  Created by Toby Hsu on 2017/4/9.
//  Copyright © 2017年 Orav. All rights reserved.
//

import UIKit
import NextGrowingTextView

class ChatViewController: UIViewController {
    @IBOutlet weak var newspaperImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var dialogView: UIView!
    @IBOutlet weak var inputTextView: NextGrowingTextView!
    @IBOutlet weak var messageViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var collectionViewBottomConstraint: NSLayoutConstraint!
    
    weak var delegate: ChatViewControllerDelegate?
    var messages: [MessageModel] = [MessageModel(id: 0, text: "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.", type: .opponent),
                                    MessageModel(id: 1, text: "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.")]
    var isExpanding: Bool = false
    var messagesWidth: [CGFloat] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        profileImageView.rounding()
        collectionView.dataSource = nil
        collectionView.keyboardDismissMode = .onDrag
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        inputTextView.maxNumberOfLines = 4
        inputTextView.textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        guard let roleString = UserDefaults.standard.value(forKey: Keys.role) as? String,
            let role = PlayerRole(rawValue: roleString) else {
                return
        }
        profileImageView.image = role == .dumboTimes ? UIImage(asset: .timesBoosIcon) : UIImage(asset: .enquirerBossIcon)
        newspaperImageView.image = role == .dumboTimes ? UIImage(asset: .timesMessagerLogo) : UIImage(asset: .enquirerMessagerLogo)
        dialogView.layer.cornerRadius = dialogView.bounds.height / 2
        dialogView.layer.borderWidth = 2
        dialogView.layer.borderColor = UIColor(hex: "#c8c8cd").cgColor
    }

    func keyboardWillHide(_ sender: Notification) {
        if let userInfo = (sender as NSNotification).userInfo {
            if let _ = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height {
                messageViewBottomConstraint.constant =  0
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    func keyboardWillShow(_ sender: Notification) {
        if let userInfo = (sender as NSNotification).userInfo {
            if let keyboardHeight = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height {
                self.messageViewBottomConstraint.constant = keyboardHeight
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    @IBAction func tapViewAction(_ sender: UITapGestureRecognizer) {
        guard let delegate = delegate else {
            return
        }
        isExpanding = !isExpanding
        
        UIView.animate(withDuration: 0.35) { [unowned self] in
            if self.isExpanding {
                self.messageView.isUserInteractionEnabled = true
                self.messageView.alpha = 1
                self.newspaperImageView.alpha = 0
            } else {
                self.messageView.isUserInteractionEnabled = false
                self.messageView.alpha = 0
                self.newspaperImageView.alpha = 1
            }
        }
        view.endEditing(true)
        
        if isExpanding {
            collectionViewBottomConstraint.constant = 0
            collectionView.dataSource = self
            collectionView.reloadData()
            collectionView.layoutIfNeeded()
            let height = collectionView.frame.maxY + collectionView.contentSize.height
            if Constants.chatVCMaxHeight < height {
                delegate.reSizeHeight(Constants.chatVCMaxHeight)
            } else {
                delegate.reSizeHeight(height)
            }
        } else {
            collectionViewBottomConstraint.constant = -messageView.bounds.height
            collectionView.dataSource = nil
            collectionView.reloadData()
            delegate.reSizeHeight(Constants.chatVCMinHeight)
        }
    }
    
    @IBAction func cameraAction(_ sender: UIButton) {
    }
    
    @IBAction func sendAction(_ sender: UIButton) {
        if !inputTextView.textView.text.isEmpty {
            messages.append(MessageModel(id: messages.count, text: inputTextView.textView.text, type: .mine))
            collectionView.performBatchUpdates({ 
                self.collectionView.insertSections(IndexSet(integer: self.messages.count - 1))
            }, completion: { (_) in
                self.collectionView.scrollToItem(at: IndexPath(item: 0, section: self.messages.count - 1), at: .bottom, animated: true)
            })
            inputTextView.textView.text = ""
            view.endEditing(true)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ChatViewController: UICollectionViewDelegate {
    
}

extension ChatViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        messagesWidth = []
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChatCell", for: indexPath) as! ChatCell
        let message = messages[indexPath.section]
        cell.textView.text = message.text
        cell.textView.textContainerInset = Constants.messageInsets
        cell.backgroundImageView.image = message.type.backgroundImage
        return cell
    }
}

extension ChatViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let message = messages[indexPath.section]
        let textView = UITextView(frame: CGRect(origin: .zero, size: CGSize(width: Constants.messageLimitSpacing - Constants.messageSpacing, height: CGFloat.greatestFiniteMagnitude)))
        textView.textContainerInset = Constants.messageInsets
        textView.font = UIFont(name: "HelveticaNeue", size: 17.0)
        textView.text = message.text
        textView.sizeToFit()
        messages[indexPath.section].width = textView.bounds.width
        return textView.bounds.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let message = messages[section]
        let spacing = UIScreen.main.bounds.width * 0.2
        if message.type == .mine {
            if let width = message.width {
                let newSpacing = width > spacing ? UIScreen.main.bounds.width - width : spacing
                return UIEdgeInsets(top: Constants.messageSpacing, left: newSpacing, bottom: 0, right: Constants.messageSpacing)
            } else {
                return UIEdgeInsets(top: Constants.messageSpacing, left: spacing, bottom: 0, right: Constants.messageSpacing)
            }
        } else {
            return UIEdgeInsets(top: Constants.messageSpacing, left: Constants.messageSpacing, bottom: 0, right: spacing)
        }
    }
}



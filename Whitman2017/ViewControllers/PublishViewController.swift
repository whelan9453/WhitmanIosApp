//
//  PublishViewController.swift
//  Whitman2017
//
//  Created by Toby Hsu on 2017/6/21.
//  Copyright © 2017年 Orav. All rights reserved.
//

import UIKit

class PublishViewController: UIViewController {
    @IBOutlet weak var readyView: UIView!
    @IBOutlet weak var completedView: UIView!
    @IBOutlet weak var sHeadlineTextField: UITextField!
    @IBOutlet weak var nHeadlineTextField: UITextField!
    @IBOutlet weak var publishButton: UIButton!
    @IBOutlet weak var resultTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultTextView.sizeToFit()
        publishButton.isEnabled = false
    }
    
    @IBAction func publishAction(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, animations: { [unowned self] in
            self.readyView.alpha = 0
            self.completedView.alpha = 1
        }) { (_) in
            self.readyView.isHidden = true
        }
    }
    @IBAction func textFieldDidChangedAction(_ sender: UITextField) {
        publishButton.isEnabled = !sHeadlineTextField.text!.isEmpty && !nHeadlineTextField.text!.isEmpty
    }

    @IBAction func tapAction(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
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

extension PublishViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let nsString = textField.text as NSString? {
            let newString = nsString.replacingCharacters(in: range, with: string)
            let stringSet = newString.trimmingCharacters(in: .whitespaces).components(separatedBy: .whitespaces).filter { !$0.isEmpty }
            if string == " " && stringSet.count == 6 {
                return false
            }
            return stringSet.count < 7
        }
        return true
    }
}

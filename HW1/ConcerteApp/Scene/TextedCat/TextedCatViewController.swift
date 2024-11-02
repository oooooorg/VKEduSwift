//
//  TextedCatViewController.swift
//  ConcerteApp
//
//  Created by Alexey Tsvetkov on 31.10.2024.
//

import UIKit

class TextedCatViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var catImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var textTextField: UITextField!
    @IBOutlet weak var generateButton: UIButton!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var catScrollView: UIScrollView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        statusLabel.text = Constants.ConstantsList.statusLabelTextReady
        activityIndicator.hidesWhenStopped = true
        generateButton.isEnabled = false
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
                view.addGestureRecognizer(gestureRecognizer)
        
        view.addGestureRecognizer(gestureRecognizer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification , object:nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification , object:nil)
    }
    
    // MARK: - Setup Methods
    @objc func keyboardWillShow(notification: NSNotification) {
       let keyboardHeight = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        catScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        catScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func resetForm () {
        generateButton.isEnabled = false
        errorMessageLabel.isHidden = false
    }
    
    
    // MARK: - Validation
    @IBAction func inputChanged(_ sender: UITextField) {
        if let userInput = textTextField.text {
            if let errrorMessage = invalidInputText(userInput) {
                errorMessageLabel.text = errrorMessage
                errorMessageLabel.isHidden = false
            } else {
                errorMessageLabel.isHidden = true
            }
        }
        checkForValidForm()
    }
    
    func invalidInputText(_ value: String) -> String? {
        if value.isEmpty {
            return Constants.ConstantsList.inputTextFieldError
        }
        return nil
    }
    
    func checkForValidForm() {
        if errorMessageLabel.isHidden {
            generateButton.isEnabled = true
        } else {
            generateButton.isEnabled = false
        }
    }
    
    // MARK: - Helper Methods
    func pullInput() -> String {
        guard let userInput = textTextField.text else {
                    return ""
                }
        return userInput
    }
        
    private func downloadCat() {
        let request = pullInput()
        guard let url = URL(string: "https://cataas.com/cat/says/\(request)?fontSize=50&fontColor=white") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.catImageView.image = UIImage(data: data)
                self?.statusLabel.text = Constants.ConstantsList.statusLabelTextEnd
                self?.activityIndicator.stopAnimating()
                self?.generateButton?.isEnabled = true
            }
        }
                
        task.resume()
    }
    
    // MARK: - Actions
    @IBAction func didTapButton(_ sender: Any) {
        (sender as? UIButton)?.isEnabled = false
        activityIndicator.startAnimating()
        statusLabel.text = Constants.ConstantsList.statusLabelTextStart
        downloadCat()
    }
}

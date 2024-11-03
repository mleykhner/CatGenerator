//
//  TextedCatGenerateViewController.swift
//  CatGenerator
//
//  Created by Максим Лейхнер on 03.11.2024.
//

import UIKit

class TextedCatGenerateViewController: UIViewController {
    @IBOutlet weak var catImage: UIImageView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    private var imageData: Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Котик говорит!"
        catImage.layer.cornerRadius = 12
        catImage.clipsToBounds = true
        textField.addTarget(self, action: #selector(checkTextField), for: .editingChanged)
        
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        
        view.addGestureRecognizer(gestureRecognizer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification , object:nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification , object:nil)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func checkTextField(_ textField: UITextField) {
        button.isEnabled = !((textField.text?.isEmpty) ?? false)
    }
    
    @IBAction func generateButtonTapped(_ sender: Any) {
        downloadCat(with: textField.text ?? "Котик молчит(")
    }
    
    func downloadCat(with text: String) {
        button.isEnabled = false
        textField.isEnabled = false
        button.titleLabel?.isHidden = true
        indicator.startAnimating()
        
        guard let url = URL(string: "https://cataas.com/cat/says/\(text)?fontSize=50&fontColor=white") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data else { return }
            
            DispatchQueue.main.async { [weak self] in
                self?.imageData = data
                self?.catImage.image = UIImage(data: data)
                self?.button.isEnabled = true
                self?.textField.isEnabled = true
                self?.button.titleLabel?.isHidden = false
                self?.indicator.stopAnimating()
                self?.catImage.isUserInteractionEnabled = true
            }
        }
        
        task.resume()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardHeight = keyboardFrame.cgRectValue.height
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        
        UIView.animate(withDuration: 0.2) {
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
        }
        
        // Прокручиваем ScrollView к активному полю
        if let activeField = textField {
            var visibleRect = scrollView.frame
            visibleRect.size.height -= keyboardHeight
            
            if !visibleRect.contains(activeField.frame.origin) {
                scrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc private func didTapView() {
        view.endEditing(true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "OpenImage" {
            guard
                let viewController: CatRotatorViewController = segue.destination as? CatRotatorViewController,
                let imageData
            else {
                return
            }
            
            viewController.setImageData(imageData)
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

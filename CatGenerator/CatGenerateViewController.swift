//
//  CatGenerateViewController.swift
//  CatGenerator
//
//  Created by Максим Лейхнер on 29.10.2024.
//

import UIKit

class CatGenerateViewController: UIViewController {
    
    @IBOutlet weak var catImage: UIImageView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    private var imageData: Data?

    override func viewDidLoad() {
        super.viewDidLoad()
        catImage.layer.cornerRadius = 12
        catImage.clipsToBounds = true
        title = "Генератор котов"

        // Do any additional setup after loading the view.
    }
    
    @IBAction func generateButtonTapped(_ sender: Any) {
        downloadCatImage()
    }
    
    private func downloadCatImage() {
        button.isEnabled = false
        button.titleLabel?.isHidden = true
        indicator.startAnimating()
        
        guard let url = URL(string: "https://cataas.com/cat") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data else { return }
            
            DispatchQueue.main.async { [weak self] in
                self?.imageData = data
                self?.catImage.image = UIImage(data: data)
                self?.button.isEnabled = true
                self?.button.titleLabel?.isHidden = false
                self?.indicator.stopAnimating()
                self?.catImage.isUserInteractionEnabled = true
            }
        }
        
        task.resume()
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

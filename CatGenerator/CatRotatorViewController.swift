//
//  CatRotatorViewController.swift
//  CatGenerator
//
//  Created by Максим Лейхнер on 03.11.2024.
//

import UIKit

class CatRotatorViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var gesture: UIRotationGestureRecognizer!
    
    private var imageData: Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gesture.addTarget(self, action: #selector(handleRotation(_:)))
        if let imageData {
            imageView.image = UIImage(data: imageData)
        }
        // Do any additional setup after loading the view.
    }
    
    @objc func handleRotation(_ gesture: UIRotationGestureRecognizer) {
        // Применяем вращение к imageView
        imageView.transform = imageView.transform.rotated(by: gesture.rotation)
        
        // Сбрасываем rotation в распознавателе, чтобы применять изменения инкрементально
        gesture.rotation = 0
    }
    
    func setImageData(_ imageData: Data) {
        self.imageData = imageData
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

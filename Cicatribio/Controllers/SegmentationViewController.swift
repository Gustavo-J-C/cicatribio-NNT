//
//  SegmentationViewController.swift
//  Cicatribio
//
//  Created by Gustavo Costa on 04/11/23.
//

import UIKit

class SegmentationViewController: UIViewController {

    var imageKey: String!
    var imageId: Int!
    var imageb64: String!
    
    let apiManager = ApiManager()
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let key = imageKey, let id = imageId, let b64 = imageb64 else {
            // Lide com a falta de dados, como exibir uma mensagem de erro
            print("Valores ausentes para key, id ou b64")
            return
        }
        
        apiManager.postToSegImg(key_img: key, img_id: id, b64img: b64) { result in
            switch result {
            case .success(let json):
                print("Resposta JSON: \(json)")
                if let base64String = json["info"] as? String,
                       let imageData = Data(base64Encoded: base64String),
                       let image = UIImage(data: imageData),
                       let areaCm = json["areaCm"] as? Double { // Certifique-se de que o tipo seja correto
                        DispatchQueue.main.async {
                            self.imageView.image = image
                            self.sizeLabel.text = String(format: "%.2f cm", areaCm)
                        }
                    }
                // Faça algo com os dados JSON aqui
            case .failure(let error):
                print("Erro: \(error)")
                // Lide com o erro de alguma forma
            }
        }
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion:  nil)
    }
    @IBAction func endAnamneseAction(_ sender: UIButton) {
        dismissToAnamnesesViewController()
    }
}

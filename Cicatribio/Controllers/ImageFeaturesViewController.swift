//
//  ImageFeaturesViewController.swift
//  Cicatribio
//
//  Created by Gustavo Costa on 24/10/23.
//

import UIKit

struct FeatureOption {
    var title: String
    var selectedValue: Int?
    var options: [DataOptionType]
}

struct PathResponse: Decodable {
    let path: String
}

class ImageFeaturesViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var featureOptions: [FeatureOption] = []
    
    let apiManager = ApiManager()
    var symptonType: Int!
    var skinType: Int!
    var injurtSite: Int!
    var exudateType: Int!
    var exudateAmount: Int!
    
    var anamneseInfo = AnamneseInfo()
    
    var imageKey: String!
    var imageId: Int!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        featureOptions = [
            FeatureOption(title: "Tipo de tecidos", options: UserManager.shared.skinTypes!),
            FeatureOption(title: "Local da ferida", options: UserManager.shared.injurySites!),
            FeatureOption(title: "Tipo exsudatos", options: UserManager.shared.exudateTypes!),
            FeatureOption(title: "Quantidade de exsudatos", options: UserManager.shared.exudateAmounts!)
        ]

        tableView.dataSource = self
        tableView.register(SelectorTableViewCell.nib(), forCellReuseIdentifier: SelectorTableViewCell.identifier)
        tableView.register(ImagePickerCustomTableViewCell.nib(), forCellReuseIdentifier: ImagePickerCustomTableViewCell.identifier)

    }
    
    @IBAction func postAnamnse(_ sender: UIButton) {
        guard let anamneseDate = anamneseInfo.selectedDate,
              let weightKg = anamneseInfo.weightKg,
              let heightM = anamneseInfo.heightM,
              let currentUser = UserManager.shared.currentUser,
              let patientID = anamneseInfo.patientId,
              let base64ImageData = anamneseInfo.base64ImageData else {
            self.view.showToast(message: "Por favor, preencha todos os campos obrigatórios.", isSuccess: false)
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let anamneseDateString = dateFormatter.string(from: anamneseDate)
        
        let postData: [String: Any] = [
            "vl_peso": weightKg,
            "vl_altura": heightM,
            "dt_anamnese": anamneseDateString,
            "mob_usuarios_id": currentUser.id,
            "mob_pacientes_id": patientID
            // Adicione outros campos e valores necessários aqui
        ]
        
        apiManager.postAnamnese(endpoint: "anamnese", postData: postData) { (data, error) in
            if let error = error {
                print("Erro na solicitação: \(error)")
            } else if let anamneseData = data {
                print(anamneseData)
                self.apiManager.postData(endpoint: "ferida", postData: ["mob_anamneses_id": anamneseData.id], dataType: InjuryType.self) { (data, error) in
                    if let error = error {
                        print("Erro ao criar a foto: \(error)")
                    } else if let injuryData = data {
                        let injuryObj: [String: Any] = [
                            "mob_tipo_sintomas_id": self.anamneseInfo.symptomType!,
                            "mob_tipo_tecidos_id": self.anamneseInfo.skinType!,
                            "mob_local_feridas_id": self.anamneseInfo.injurySite!,
                            "mob_tipo_exsudatos_id": self.anamneseInfo.exudateType!,
                            "mob_qtd_exsudatos_id": self.anamneseInfo.exudateAmount!,
                            "mob_feridas_id": injuryData.id!,
                            "vl_comprimento": NSNull(),
                            "vl_largura": NSNull()
                        ]
                        
                        self.apiManager.checkerPost(b64: base64ImageData) { result in
                            switch result {
                            case .success(let json):
                                if let info = json["info"] as? [String: Any], // Verifica se "info" é um dicionário
                                   let hashtag = info["hasTag"] as? Bool, hashtag == true {
                                    self.continuePostSequence(injuryData: injuryData, injuryObj: injuryObj)
                                } else {
                                    DispatchQueue.main.async {
                                        self.view.showToast(message: "Não foi possível validar a imagem", isSuccess: false)
                                    }
                                }
                            case .failure(let error):
                                print("Erro: \(error)")
                                // Lide com o erro de alguma forma
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    func continuePostSequence(injuryData: InjuryType, injuryObj: [String: Any]) {
        self.apiManager.postData(endpoint: "caracteristicasFerida", postData: injuryObj, dataType: InjuryType.self) { (data, error) in
            if let error = error {
                print("Erro ao enviar características da ferida: \(error)")
            } else if let injuryInfos = data {
                self.apiManager.postData(endpoint: "imagens_feridas", postData: ["mob_caracteristicas_feridas_id": injuryInfos.id!, "mob_feridas_id": injuryData.id!] as [String: Any], dataType: FeridaInfo.self) { (data, error) in
                    if let error = error {
                        print("Erro ao enviar dados da imagem da Ferida \(error)")
                    } else if let injuryImageInfo = data {
                        self.imageId = injuryImageInfo.id
                        self.apiManager.postData(endpoint: "uploadB64", postData: ["b64": self.anamneseInfo.base64ImageData!, "id": injuryImageInfo.id!], dataType: PathResponse.self) { (data, error) in
                            if let error {
                                print("Erro ao enviar o base64 \(error)")
                            } else if let b64imageData = data {
                                self.imageKey = b64imageData.path
                                DispatchQueue.main.async {
                                    self.performSegue(withIdentifier: "goToNext", sender: self)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    @IBAction func handleBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToNext" {
            if let nextViewController = segue.destination as? SegmentationViewController {
                nextViewController.imageb64 = anamneseInfo.base64ImageData
                nextViewController.imageId = imageId
                nextViewController.imageKey = imageKey
            }
        }
    }
}

extension ImageFeaturesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < 4 {
            let option = featureOptions[indexPath.row]
            let customCell = tableView.dequeueReusableCell(withIdentifier: SelectorTableViewCell.identifier, for: indexPath) as! SelectorTableViewCell
            customCell.configure(with: option.options, title: option.title, tag: indexPath.row)
            customCell.delegate = self
            return customCell
        } else {
            
            let customCell = tableView.dequeueReusableCell(withIdentifier: ImagePickerCustomTableViewCell.identifier, for: indexPath) as! ImagePickerCustomTableViewCell

            customCell.delegate = self
            return customCell
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
}

extension ImageFeaturesViewController: SelectorTableViewCellDelegate, ImagePickerCustomTableViewCellDelegate {
    
    func imageDidSelected(image: UIImage?) {
        if let base64String = imageToBase64(image: image) {
            anamneseInfo.base64ImageData = base64String
        }
    }
    
    func pickerViewDidSelectValue(_ value: Int, tag: Int) {
        switch tag {
        case 0:
            anamneseInfo.skinType = value
        case 1:
            anamneseInfo.injurySite = value
        case 2:
            anamneseInfo.exudateType = value
        case 3:
            anamneseInfo.exudateAmount = value
        default:
            break
        }
    }
    
    func imageToBase64(image: UIImage?) -> String? {
        guard let image = image,
            let imageData = image.jpegData(compressionQuality: 1.0) else {
            return nil
        }
        
        let base64String = imageData.base64EncodedString(options: [])
        return base64String
    }
    
    func takePictureButtonTapped(with picker: UIImagePickerController) {
        present(picker, animated: true)
    }
    
    func chooseImageButtonTapped(with picker: UIImagePickerController) {
        present(picker, animated: true)
    }

}

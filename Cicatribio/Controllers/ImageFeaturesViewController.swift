//
//  ImageFeaturesViewController.swift
//  Cicatribio
//
//  Created by Gustavo Costa on 24/10/23.
//

import UIKit

class ImageFeaturesViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    let titles = ["Tipo de sintomas", "Tipo de tecidos","Local da ferida", "Tipo exsudatos", "Quantidade de exsudatos"]
    let types : [[DataOptionType]?] = [UserManager.shared.symptomsTypes, UserManager.shared.skinTypes, UserManager.shared.injurySites,  UserManager.shared.exudateTypes, UserManager.shared.exudateAmounts]
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.register(SelectorTableViewCell.nib(), forCellReuseIdentifier: SelectorTableViewCell.identifier)

    }

    @IBAction func handleBakc(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func takePictureAction(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.sourceType = .camera
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @IBAction func chooseImageAction(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any] ) {
        guard let image =  info[.editedImage] as? UIImage else {return}
        
        imageView.image = image
        
        dismiss(animated: true)
    }
}

extension ImageFeaturesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let customCell = tableView.dequeueReusableCell(withIdentifier: SelectorTableViewCell.identifier, for: indexPath) as! SelectorTableViewCell
        
        customCell.configure(with: types[indexPath.row]!, title: titles[indexPath.row])
        customCell.delegate = self
        return customCell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
}

extension ImageFeaturesViewController: SelectorTableViewCellDelegate {
    func pickerViewDidSelectValue(_ value: String) {
        print(value)
    }
}

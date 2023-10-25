//
//  ImageFeaturesViewController.swift
//  Cicatribio
//
//  Created by Gustavo Costa on 24/10/23.
//

import UIKit

class ImageFeaturesViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    let titles = ["Tipo de sintomas", "Tipo de tecidos","Local da ferida", "Tipo exsudatos", "Quantidade de exsudatos"]
    let types : [[DataOptionType]?] = [UserManager.shared.symptomsTypes, UserManager.shared.skinTypes, UserManager.shared.injurySites,  UserManager.shared.exudateTypes, UserManager.shared.exudateAmounts]
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.register(SelectorTableViewCell.nib(), forCellReuseIdentifier: SelectorTableViewCell.identifier)
        tableView.register(ImagePickerCustomTableViewCell.nib(), forCellReuseIdentifier: ImagePickerCustomTableViewCell.identifier)

    }

    @IBAction func handleBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ImageFeaturesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < 5 {
            let customCell1 = tableView.dequeueReusableCell(withIdentifier: SelectorTableViewCell.identifier, for: indexPath) as! SelectorTableViewCell
            
            customCell1.configure(with: types[indexPath.row]!, title: titles[indexPath.row])
            customCell1.delegate = self
            return customCell1
        } else {
            
            let customCell = tableView.dequeueReusableCell(withIdentifier: ImagePickerCustomTableViewCell.identifier, for: indexPath) as! ImagePickerCustomTableViewCell

            customCell.delegate = self
            return customCell
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
}

extension ImageFeaturesViewController: SelectorTableViewCellDelegate, ImagePickerCustomTableViewCellDelegate {
    
    func imageDidSelected(image: UIImage?) {
        
    }
    
    func pickerViewDidSelectValue(_ value: String) {
        print(value)
    }
    
    func takePictureButtonTapped(with picker: UIImagePickerController) {
        present(picker, animated: true)
    }
    
    func chooseImageButtonTapped(with picker: UIImagePickerController) {
        present(picker, animated: true)
    }

}

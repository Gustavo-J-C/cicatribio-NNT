//
//  ImagePickerCustomTableViewCell.swift
//  Cicatribio
//
//  Created by Gustavo Costa on 24/10/23.
//

import UIKit

protocol ImagePickerCustomTableViewCellDelegate: AnyObject {
    func imageDidSelected(image: UIImage?)
    func takePictureButtonTapped(with picker: UIImagePickerController)
    func chooseImageButtonTapped(with picker: UIImagePickerController)
}

class ImagePickerCustomTableViewCell: UITableViewCell, UINavigationControllerDelegate {

    static let identifier: String = "ImagePickerCustomTableViewCell"
    var selectedImage : UIImage!
    
    @IBOutlet weak var CameraButton: UIButton!
    @IBOutlet weak var storageButton: UIButton!
    @IBOutlet weak var myImageView: UIImageView!
    weak var delegate: ImagePickerCustomTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "ImagePickerCustomTableViewCell", bundle: nil)
    }
    
    func configure(with base64Image: String?) {
        guard let base64Image = base64Image else {
            myImageView.image = nil
            return
        }
        
        if let imageData = Data(base64Encoded: base64Image), let image = UIImage(data: imageData) {
            myImageView.image = image
        } else {
            myImageView.image = nil
        }
        storageButton.isUserInteractionEnabled = false
        CameraButton.isUserInteractionEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func takePictureAction(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.sourceType = .camera
        picker.delegate = self
        delegate?.takePictureButtonTapped(with: picker)
    }
    
    @IBAction func chooseImageAction(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        delegate?.chooseImageButtonTapped(with: picker)
    }
}

extension ImagePickerCustomTableViewCell: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            picker.dismiss(animated: true)
            return
        }
        print(image.size)
        myImageView!.image = image
        delegate?.imageDidSelected(image: image)
        
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

//
//  CustomAnamneseCell.swift
//  Cicatribio
//
//  Created by Gustavo Costa on 21/10/23.
//

import UIKit

protocol CustomAnamneseCellDelegate: AnyObject {
    func didDeleteItem()
}

class CustomAnamneseCell: UITableViewCell {

    static let identifier = "CustomAnamneseCell"
    var parentViewController: UIViewController?
    
    weak var delegate: CustomAnamneseCellDelegate?
    
    let apiManager = ApiManager()
    var anamnese: Anamnese?
    @IBOutlet weak var deleteButton: UIButton!
    
    static func nib() -> UINib{
        return UINib(nibName: "CustomAnamneseCell", bundle: nil)
    }
    
    public func configure(with anamnese: Anamnese, parent: UIViewController, delegate: CustomAnamneseCellDelegate) {
        self.delegate = delegate
        dateLabel.text = anamnese.dt_anamnese!.formatted()
        parentViewController = parent
        self.anamnese = anamnese
    }
    
    @IBOutlet weak var dateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func handleDelete(_ sender: UIButton) {
        if let mobUsuariosId = anamnese?.mob_usuarios_id, let id = anamnese?.id {
            
            let alertController = UIAlertController(title: "Confirmação", message: "Tem certeza de que deseja excluir esta anamnese?", preferredStyle: .alert)
                    
            alertController.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
            
            alertController.addAction(UIAlertAction(title: "Excluir", style: .destructive, handler: { action in
                // O usuário confirmou a exclusão, então podemos prosseguir
                self.apiManager.deleteAnamnese(mobUsuariosId: String(mobUsuariosId), id: String(id)) { success in
                    if success {
                        // A exclusão foi bem-sucedida, você pode realizar ações adicionais aqui
                        print("Anamnese excluída com sucesso.")
                        self.delegate?.didDeleteItem()
                    } else {
                        // A exclusão falhou, você pode lidar com o erro aqui
                        print("Erro ao excluir a anamnese.")
                    }
                }
            }))
            
            parentViewController!.present(alertController, animated: true, completion: nil)
        }
    }
}


//
//  NewAvaliationViewController.swift
//  Cicatribio
//
//  Created by Gustavo Costa on 23/10/23.
//

import UIKit

class NewAnamenseViewController: UIViewController {
    
    var anamneseInfo = AnamneseInfo()
    var review = false
    var reviewData: Anamnese!
    
    @IBOutlet weak var tableView: UITableView!
//    var cordinator: UICoordinator
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.register(DateTableViewCell.nib(), forCellReuseIdentifier: DateTableViewCell.identifier)
        tableView.register(TextTableViewCell.nib(), forCellReuseIdentifier: TextTableViewCell.identifier)
        anamneseInfo.selectedDate = Date()
    }
    


    @IBAction func handleBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func handleNext(_ sender: UIButton) {
        if !review {
            guard let weightKg = anamneseInfo.weightKg,
                  let heightM = anamneseInfo.heightM else {
                print(anamneseInfo)
                self.view.showToast(message: "Preencha todos os campos obrigatórios", isSuccess: false)
                return
            }

            // Agora você pode usar os valores de selectedDate, weightKg e heightM sem se preocupar com nulos
            // ...

            // Exemplo adicional: Verifique se os valores são maiores que zero (ou outra condição apropriada)
            if weightKg <= 0 || heightM <= 0 {
                self.view.showToast(message: "Os valores devem ser maiores que zero", isSuccess: false)
                return
            }

            // Se tudo estiver correto, continue com o restante do código
        }
        self.performSegue(withIdentifier: "goToNext", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToNext" {
            if let nextViewController = segue.destination as? ImageFeaturesViewController {
                nextViewController.anamneseInfo = anamneseInfo
                if review {
                    nextViewController.review = true
                    nextViewController.reviewData = reviewData
                }
            }
        }
    }

}

extension NewAnamenseViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let dateCell = tableView.dequeueReusableCell(withIdentifier: DateTableViewCell.identifier, for: indexPath) as! DateTableViewCell
            
            dateCell.configure(with: "Data e Hora:", delegate: self)
            
            // Desativar a interação com o datePicker durante a revisão
            dateCell.datePicker.isUserInteractionEnabled = !review
            
            if review, let date = reviewData.dt_anamnese {
                dateCell.datePicker.date = date
            } else {
                dateCell.datePicker.date = anamneseInfo.selectedDate ?? Date()
            }
            
            return dateCell
        }
        let textCell = tableView.dequeueReusableCell(withIdentifier: TextTableViewCell.identifier, for: indexPath) as! TextTableViewCell
        
        if review {
            textCell.textField.isUserInteractionEnabled = false
        }
        switch indexPath.row {
        case 1:
            textCell.configure(with: "Peso (kg):", delegate: self, value: review ? reviewData.vl_peso?.description : nil)
        case 2:
            textCell.configure(with: "Altura (m):", delegate: self, value: review ? reviewData.vl_altura?.description : nil)
        default:
            break
        }
        return textCell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.rowHeight = 90
    }
    
}

extension NewAnamenseViewController: DatePickerCellDelegate {
    func dateDidChange(newDate: Date) {
        print(newDate)
        anamneseInfo.selectedDate = newDate
    }
}

extension NewAnamenseViewController: TextTableViewCellDelegate {
    func textFieldDidChange(_ text: String, for key: String) {
        print(text)
        if let value = Double(text) {
            switch key {
            case "Peso (kg):":
                anamneseInfo.weightKg = value
            case "Altura (m):":
                // Atualize a propriedade de altura
                anamneseInfo.heightM = value
            default:
                break
            }
        } else {
            self.view.showToast(message: "Valor deve ser um numero ex: '2.1'", isSuccess: false)
        }
    }
}

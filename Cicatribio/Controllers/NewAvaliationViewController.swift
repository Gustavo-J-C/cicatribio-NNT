//
//  NewAvaliationViewController.swift
//  Cicatribio
//
//  Created by Gustavo Costa on 23/10/23.
//

import UIKit

class NewAnamenseViewController: UIViewController {
    
    var anamneseInfo = AnamneseInfo()
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
        guard let selectedDate = anamneseInfo.selectedDate, let weightKg = anamneseInfo.weightKg, let heightM = anamneseInfo.heightM else {
            print(anamneseInfo)
            self.view.showToast(message: "Preencha todos os campos obrigatórios", isSuccess: false)
            return
        }
        self.performSegue(withIdentifier: "goToNext", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToNext" {
            if let nextViewController = segue.destination as? RiskFactorsViewController {
                nextViewController.anamneseInfo = anamneseInfo
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
            
            dateCell.configure(with: "Data e Hora", delegate: self)
            return dateCell
        }
        let textCell = tableView.dequeueReusableCell(withIdentifier: TextTableViewCell.identifier, for: indexPath) as! TextTableViewCell
        
        switch indexPath.row {
        case 1:
            textCell.configure(with: "Peso (kg)", delegate: self )
        case 2:
            textCell.configure(with: "Altura (m)", delegate: self )
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
            case "Peso (kg)":
                anamneseInfo.weightKg = value
            case "Altura (m)":
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

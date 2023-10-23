//
//  RiskFactorsViewController.swift
//  Cicatribio
//
//  Created by Gustavo Costa on 23/10/23.
//

import UIKit

class RiskFactorsViewController: UIViewController {

    let countrys = ["pais1", "pais2", "pais3"]
    let titles = ["Tipo de mobilidade", "Autocuidado", "Tipo Higiene"]
    
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.register(SelectorTableViewCell.nib(), forCellReuseIdentifier: SelectorTableViewCell.identifier)
    }
    
    @IBAction func handleBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}

extension RiskFactorsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < 3 {
            let customCell = tableView.dequeueReusableCell(withIdentifier: SelectorTableViewCell.identifier, for: indexPath) as! SelectorTableViewCell
            
            customCell.titleLabel.text = titles[indexPath.row]
            customCell.searchTextField.placeholder = titles[indexPath.row]
            customCell.delegate = self
            return customCell
        }
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell\(indexPath.row + 1)", for: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row < 3 {
            // Altura personalizada para as células customizadas
            return 150.0 // Ajuste o valor conforme necessário
        } else {
            // Altura padrão para as outras células
            return 44.0 // Ajuste o valor conforme necessário
        }
    }
}

extension RiskFactorsViewController: SelectorTableViewCellDelegate {
    func pickerViewDidSelectValue(_ value: String) {
        print(value)
    }
}

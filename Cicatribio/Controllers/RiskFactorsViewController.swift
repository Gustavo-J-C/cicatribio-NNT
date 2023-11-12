//
//  RiskFactorsViewController.swift
//  Cicatribio
//
//  Created by Gustavo Costa on 23/10/23.
//

import UIKit

class RiskFactorsViewController: UIViewController {

    var anamneseInfo = AnamneseInfo()
    let titles = ["Autocuidado", "Tipo Higiene", "Tipo sintomas"]
    let types : [[DataOptionType]?] = [ UserManager.shared.selfCareTypes, UserManager.shared.hygieneTypes, UserManager.shared.symptomsTypes ]
    
    var reviewTypes: [DataOptionType]?
    var review = false
    var reviewData: Anamnese!
    var riskId: Int!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.register(SelectorTableViewCell.nib(), forCellReuseIdentifier: SelectorTableViewCell.identifier)
        
    }
    
    @IBAction func handleBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func handleNext(_ sender: UIButton) {
        if anamneseInfo.mobilitType != nil, anamneseInfo.selfCare != nil, anamneseInfo.hygieneType != nil, anamneseInfo.symptomType != nil {
            self.performSegue(withIdentifier: "goToNext", sender: self)
        } else {
            self.view.showToast(message: "Por favor, preencha todos os campos obrigatórios.", isSuccess: false)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToNext" {
            if let nextViewController = segue.destination as? ImageFeaturesViewController {
                nextViewController.anamneseInfo = anamneseInfo
            }
        }
    }
    
}

extension RiskFactorsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {            
        let customCell = tableView.dequeueReusableCell(withIdentifier: SelectorTableViewCell.identifier, for: indexPath) as! SelectorTableViewCell
            
            customCell.configure(with: types[indexPath.row]!, title: titles[indexPath.row], tag: indexPath.row)
            customCell.delegate = self
        if review {
            customCell.searchTextField.isUserInteractionEnabled = false
        }
            return customCell
    }
}

extension RiskFactorsViewController: SelectorTableViewCellDelegate {
    func pickerViewDidSelectValue(_ value: Int, tag: Int) {
        print(tag, value)
        switch tag {
        case 0:
            anamneseInfo.mobilitType = value
        case 1:
            anamneseInfo.selfCare = value
        case 2:
            anamneseInfo.hygieneType = value
        case 3: anamneseInfo.symptomType = value
        default:
            break
        }
    }
}

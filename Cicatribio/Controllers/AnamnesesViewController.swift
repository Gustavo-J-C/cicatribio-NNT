//
//  AnamnesesViewController.swift
//  Cicatribio
//
//  Created by Gustavo Costa on 21/10/23.
//

import UIKit

class AnamnesesViewController: UIViewController, ApiManagerDelegate {
    
    var apiManager = ApiManager()
    var patientAnamneses: [Anamnese] = []
    
    var currentPatient: PatientsData! = nil
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        apiManager.delegate = self
        tableView.register(CustomAnamneseCell.nib(), forCellReuseIdentifier: CustomAnamneseCell.identifier )
        tableView.delegate = self
        tableView.dataSource = self
        fetchDataFromAPI()
        // Do any additional setup after loading the view.
    }
    
    func didUpdateData<T>(_ data: T?) {
        if let data = data {
            if let anamnesesData = data as? [Anamnese] {
                // Trata a chegada de dados de pacientes
                self.patientAnamneses = anamnesesData
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func fetchDataFromAPI() {
        apiManager.fetchData(endpoint: "anamneses/user/1/\(currentPatient.id)", type: [Anamnese].self)
    }
    
    
    @IBAction func handleBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func handleNewAnamnese(_ sender: Any) {
        self.performSegue(withIdentifier: "goToNext", sender: self)
    }
    
}

extension AnamnesesViewController: UITableViewDelegate{

}

extension AnamnesesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return patientAnamneses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let customCell = tableView.dequeueReusableCell(withIdentifier: CustomAnamneseCell.identifier, for: indexPath) as! CustomAnamneseCell
        customCell.configure(with: patientAnamneses[indexPath.row].dt_anamnese)
        return customCell
    }
    
}

//
//  AnamnesesViewController.swift
//  Cicatribio
//
//  Created by Gustavo Costa on 21/10/23.
//

import UIKit

class AnamnesesViewController: UIViewController, ApiManagerDelegate {
    
    var user : User!
    var apiManager = ApiManager()
    var patientAnamneses: [Anamnese] = []
    
    var currentPatient: PatientsData! = nil
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        user = UserManager.shared.currentUser!
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
        apiManager.fetchData(endpoint: "anamneses/user/\(user.id)/\(currentPatient.id)", type: [Anamnese].self)
    }
    
    @IBAction func handleNewAnamnese(_ sender: Any) {
        self.performSegue(withIdentifier: "goToNext", sender: self)
//        let storyboard = UIStoryboard(name: "RegisterPatient", bundle: .init(for: RegisterPatientViewController.self))
//        guard let viewController = storyboard.instantiateViewController(withIdentifier: RegisterPatientViewController.identifier) as? RegisterPatientViewController else { return }

//        viewController.hidesBottomBarWhenPushed = false

//        navigationController?.pushViewController(viewController, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToNext" {
            if let nextViewController = segue.destination as? NewAnamenseViewController {
                nextViewController.anamneseInfo.patientId = currentPatient.id
            }
        }
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
        if let dtAnamnese = patientAnamneses[indexPath.row].dt_anamnese {
            // Agora você pode usar dtAnamnese com segurança, pois não é nulo
            customCell.configure(with: dtAnamnese)
        }
        return customCell
    }
    
}

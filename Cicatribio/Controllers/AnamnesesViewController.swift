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
    var anamnese: Anamnese!
    
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
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToNext" {
            if let nextViewController = segue.destination as? NewAnamenseViewController {
                nextViewController.anamneseInfo.patientId = currentPatient.id
            }
        }        
        if segue.identifier == "goToReview" {
            if let nextViewController = segue.destination as? NewAnamenseViewController {
                nextViewController.anamneseInfo.patientId = currentPatient.id
                apiManager.getFullAnamnese(anamneseId: anamnese.id) { anamnese, error in
                    if let anamnese = anamnese {
                        nextViewController.reviewData = anamnese
                        nextViewController.review = true
                    } else {
                        // Tratar erro
                        print("Erro ao obter a anamnese completa:", error ?? "Erro desconhecido")
                    }
                }
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
        customCell.configure(with: patientAnamneses[indexPath.row], parent: self, delegate: self)
        
        return customCell
    }
    
}

extension AnamnesesViewController: CustomAnamneseCellDelegate {
    func goToReview(with anamnese: Anamnese) {
        self.anamnese = anamnese
        self.performSegue(withIdentifier: "goToReview", sender: self)
    }
    
    func didDeleteItem() {
        // Lidar com a notificação da exclusão aqui
        // Use o índice para manipular o item correto
        // Por exemplo, remova o item da fonte de dados
        // e recarregue a tabela
        self.apiManager.fetchData(endpoint: "anamneses/user/\(user.id)/\(currentPatient.id)", type: [Anamnese].self)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    

}

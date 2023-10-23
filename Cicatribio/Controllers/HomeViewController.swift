//
//  HomeViewController.swift
//  Cicatribio
//
//  Created by user on 04/10/23.
//

import UIKit

class HomeViewController: UIViewController, UITextFieldDelegate, ApiManagerDelegate {
        
    var userId: Int?
    var userName: String?;
    var userEmail: String?;
    
    var selectedIndexPath: IndexPath?
    
    @IBOutlet weak var searchTextField: UITextField!
    
    var apiManager = ApiManager()
    var patientsData: [PatientsData] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var filteredPatientsData: [PatientsData] = []
    
    @objc func searchTextFieldDidChange() {
        if let searchText = searchTextField.text, !searchText.isEmpty {
            // Use the searchText to filter patientsData
            filteredPatientsData = patientsData.filter { $0.no_completo.localizedCaseInsensitiveContains(searchText) }
        } else {
            // If the search field is empty, show all patientsData
            filteredPatientsData = patientsData
        }
        
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        apiManager.delegate = self
        tableView.register(MyTableViewCell.nib(), forCellReuseIdentifier: MyTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        fetchDataFromAPI()
        
        searchTextField.addTarget(self, action: #selector(searchTextFieldDidChange), for: .editingChanged)
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
        return true
    }
    
    func didUpdateData<T>(_ data: T?) {
        if let data = data {
            if let patientsData = data as? [PatientsData] {
                // Trata a chegada de dados de pacientes
                self.patientsData = patientsData
                self.filteredPatientsData = patientsData
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func fetchDataFromAPI() {
        apiManager.fetchData(endpoint: "pacientes", type: [PatientsData].self)
    }
    
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        self.performSegue(withIdentifier: "goToAnamnese", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToAnamnese" {
            if let destinationVC = segue.destination as? AnamnesesViewController {
                if let indexPath = selectedIndexPath {
                    destinationVC.currentPatient = filteredPatientsData[indexPath.row]
                }
            }
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPatientsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let customCell = tableView.dequeueReusableCell(withIdentifier: MyTableViewCell.identifier, for: indexPath) as! MyTableViewCell
        customCell.configure(with: filteredPatientsData[indexPath.row].no_completo, sex: filteredPatientsData[indexPath.row].ds_sexo, birthday: filteredPatientsData[indexPath.row].dt_nascimento)
        return customCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    @objc func didChangeSwitch(_ sender: UISwitch) {
        if sender.isOn {
            print("User turned it on")
        } else {
            print("It`s now off")
        }
    }
}

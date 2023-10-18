//
//  HomeViewController.swift
//  Cicatribio
//
//  Created by user on 04/10/23.
//

import UIKit

class HomeViewController: UIViewController, UITextFieldDelegate {
    
    var userId: Int?
    var userName: String?;
    var userEmail: String?;
    @IBOutlet weak var searchTextField: UITextField!
    
    let apiManager = ApiManager()
    
    @IBOutlet weak var tableView: UITableView!
    let arrayMemes:[String] = ["meme1", "meme2", "meme3"];
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(MyTableViewCell.nib(), forCellReuseIdentifier: MyTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        fetchDataFromAPI()
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
    
    
    func fetchDataFromAPI() {
        apiManager.fetchUsers(endpoint: "pacientes")
    }
    
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("you tapped me!")
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row > 2 {
            let customCell = tableView.dequeueReusableCell(withIdentifier: MyTableViewCell.identifier, for: indexPath) as! MyTableViewCell
            customCell.configure(with: "Custom Cell", imageName: "gear")
            return customCell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let mySwitch = UISwitch()
        mySwitch.addTarget(self , action: #selector(didChangeSwitch(_:)), for: .valueChanged)
        cell.accessoryView = mySwitch
        cell.textLabel?.text = "Hello World"
        return cell
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

//
//  RegisterPatientViewController.swift
//  Cicatribio
//
//  Created by Gustavo Costa on 25/10/23.
//

import UIKit

class RegisterPatientViewController: UIViewController {

    static let identifier: String = "RegisterPatientViewController"
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
    }

}

extension RegisterPatientViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell\(indexPath.row + 1)", for: indexPath)
        return cell
    }
    
    
}

extension RegisterPatientViewController: UITableViewDelegate {
    
}

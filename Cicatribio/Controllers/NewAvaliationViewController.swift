//
//  NewAvaliationViewController.swift
//  Cicatribio
//
//  Created by Gustavo Costa on 23/10/23.
//

import UIKit

class NewAnamenseViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    

    @IBAction func handleBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func handleNext(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToNext", sender: self)
    }
    
}

extension NewAnamenseViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell\(indexPath.row + 1)", for: indexPath)
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.rowHeight = 90
    }
    
}

//
//  EditProfileViewController.swift
//  Cicatribio
//
//  Created by Gustavo Costa on 04/11/23.
//

import UIKit

class EditProfileViewController: UIViewController, PhoneCellDelegate {
    func phoneCell(_ cell: PhoneTableViewCell, didChangePhoneNumber phoneNumber: String) {

    }
    

    @IBOutlet weak var tableView: UITableView!
    static let identifier: String = "EditProfileViewController"
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PhoneTableViewCell.nib(), forCellReuseIdentifier: PhoneTableViewCell.identifier)
    }

}

extension EditProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let phoneCell = tableView.dequeueReusableCell(withIdentifier: PhoneTableViewCell.identifier, for: indexPath) as! PhoneTableViewCell
            return phoneCell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell\(indexPath.row)", for: indexPath)
        return cell
    }
    
    
}

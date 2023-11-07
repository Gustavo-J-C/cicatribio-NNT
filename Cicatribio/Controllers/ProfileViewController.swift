//
//  ProfileViewController.swift
//  Cicatribio
//
//  Created by Gustavo Costa on 04/11/23.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        userNameLabel.text = UserManager.shared.currentUser?.no_completo
        emailLabel.text = UserManager.shared.currentUser?.ds_email
    }

    @IBAction func logout(_ sender: UIButton) {
        UserDefaults.standard.removeObject(forKey: "currentUser")
        UserManager.shared.currentUser = nil
        self.dismiss(animated: true, completion: nil)
    }
    
    func handleEditProfile() {
        let storyboard = UIStoryboard(name: "EditProfile", bundle: .init(for: EditProfileViewController.self))
        guard let viewController = storyboard.instantiateViewController(withIdentifier: EditProfileViewController.identifier) as? EditProfileViewController else { return }

        viewController.hidesBottomBarWhenPushed = false

        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell\(indexPath.row)", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        handleEditProfile()
    }
    
}

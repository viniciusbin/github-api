//
//  DetailViewController.swift
//  githubAPI
//
//  Created by Vinicius on 04/10/22.
//

import UIKit

class DetailViewController: UIViewController {
    
    var gitUser: String = ""
    let service = GitService()
    var userDetail: UserDetail?
    
    var repos = [Repo]() {
        didSet {
            tableview.reloadData()
        }
    }
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureScene()
        
        service.getUser(gitUser: gitUser) { result in
            DispatchQueue.main.async {
                switch result {
                    
                case let .success(result):
                    self.userDetail = result
                    self.populateData()
                case let .failure(error):
                    print(error)
                }
            }
        }
        
        service.getRepo(gitUser: gitUser) { result in
            DispatchQueue.main.async {
                switch result {
                    
                case let .success(result):
                    self.repos = result
                    print(self.repos)
                case let .failure(error):
                    print(error)
                }
            }
        }
    }
    
    func populateData() {
        loginLabel.text = "Login: " + (userDetail?.login ?? "")
        idLabel.text = "ID: " + (userDetail?.id?.formatted() ?? "")
        nameLabel.text = "Nome Completo: " + (userDetail?.name ?? "")
        avatarImageView.downloaded(from: userDetail?.avatar_url ?? "")
    }
    
    func configureScene() {
        tableview.delegate = self
        tableview.dataSource = self
        avatarImageView.layer.borderWidth = 3.0
        avatarImageView.layer.borderColor = UIColor.black.cgColor
        avatarImageView.layer.cornerRadius = 10
    }
    


}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        repos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let indexRepo = repos[indexPath.row]
        cell.textLabel?.text = "Nome Repo: " + indexRepo.name
        cell.detailTextLabel?.text = "Descrição: " + (indexRepo.description ?? "Sem descrição")
        cell.detailTextLabel?.numberOfLines = 0
        return cell
    }
    
    
}

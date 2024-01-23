//
//  ViewController.swift
//  Homework_API
//
//  Created by Vlad on 22.01.24.
//

import UIKit

struct User: Codable {
    let name: String
    let email: String

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.email, forKey: .email)
    }
    
    enum CodingKeys: CodingKey {
        case name
        case email
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.email = try container.decode(String.self, forKey: .email)
    }
}

class ViewController: UIViewController {
    
    var arrayUsers: [User] = []
    
    let tableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUsers()
        setupTableView()

    }
    
    func getUsers() {
        let url = URL(string: "https://jsonplaceholder.typicode.com/users")!
        let urlRequest = URLRequest(url: url)
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            let dict = try! JSONSerialization.jsonObject(with: data!)
            print(dict)
            
            let users = try! JSONDecoder().decode([User].self, from: data!)
            
            self.arrayUsers = users
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }.resume()
    }
    
    func setupTableView() {
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        tableView.dataSource = self
    }


}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        var configurationCell = UIListContentConfiguration.cell()
        configurationCell.text = "Name: \(arrayUsers[indexPath.row].name), email: \(arrayUsers[indexPath.row].email)"
        
        cell.contentConfiguration = configurationCell
        
        return cell
    }
}


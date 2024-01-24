//
//  ViewController.swift
//  Homework_API
//
//  Created by Vlad on 22.01.24.
//

import UIKit

// MARK: - ToDo
struct ToDo: Codable {
    let id: Int
    let name, username, email: String
    let address: Address
    let phone, website: String
    let company: Company
    
    enum CodingKeys: CodingKey {
        case id
        case name
        case username
        case email
        case address
        case phone
        case website
        case company

    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.username, forKey: .username)
        try container.encode(self.email, forKey: .email)
        try container.encode(self.address, forKey: .address)
        try container.encode(self.phone, forKey: .phone)
        try container.encode(self.website, forKey: .website)
        try container.encode(self.company, forKey: .company)

    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.username = try container.decode(String.self, forKey: .username)
        self.email = try container.decode(String.self, forKey: .email)
        self.address = try container.decode(Address.self, forKey: .address)
        self.phone = try container.decode(String.self, forKey: .phone)
        self.website = try container.decode(String.self, forKey: .website)
        self.company = try container.decode(Company.self, forKey: .company)
    }
}

// MARK: - Address
struct Address: Codable {
    let street, suite, city, zipcode: String
    let geo: Geo
}

// MARK: - Geo
struct Geo: Codable {
    let lat, lng: String
}

// MARK: - Company
struct Company: Codable {
    let name, catchPhrase, bs: String
}

class ViewController: UIViewController {
    
    var arrayUsers: [ToDo] = []
    
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
            
            let todo = try! JSONDecoder().decode([ToDo].self, from: data!)

            self.arrayUsers = todo
            
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


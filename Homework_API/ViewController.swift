//
//  ViewController.swift
//  Homework_API
//
//  Created by Vlad on 22.01.24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: "https://jsonplaceholder.typicode.com/users")!
        let urlRequest = URLRequest(url: url)
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            let dict = try! JSONSerialization.jsonObject(with: data!)
            print(dict)
            
        }.resume()

    }


}


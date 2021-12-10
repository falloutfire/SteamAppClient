//
//  File.swift
//  Pokedex
//
//  Created by Ilya Manny on 17.09.2021.
//

import UIKit

//class InitViewController: UIViewController {
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .systemBackground
//    }
//    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//        //try? router.navigate(to: AppNavigationConfigurationHolder.configuration.mainScreen, with: nil)
//    }
//}

//
//  ViewController.swift
//  eststst
//
//  Created by Ilya Manny on 11.11.2021.
//

import UIKit


enum UserType: String, Codable {
    case UserTypeNotVerified = "NotVerified"
    case UserTypeAuthorized = "Authorized"
    case UserTypePremium = "Premium"
}
let UserTypeNotVerified = "NotVerified"
let UserTypeAuthorized = "Authorized"
let UserTypePremium = "Premium"

struct User: Codable {
    
    var id: Int?
    var name: String
    var status: UserType
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case status
    }
}

class BaseLoader {
    
    var url: String?
    let qualityOfService: DispatchQoS.QoSClass
    
    init(aQualityOfService: DispatchQoS.QoSClass) {
        qualityOfService = aQualityOfService
    }
    
}

class UserListLoader: BaseLoader {
    
    init(anUrl: String) {
        super.init(aQualityOfService: .userInitiated)
        self.url = anUrl
    }
    
    func loadusers(completion: @escaping (Result<[User], Error>) -> Void) {
        if let loadUrlString = url, let loadUrl = URL(string: loadUrlString) {
            DispatchQueue.global(qos: qualityOfService).async {
                let task = URLSession.shared.dataTask(with: URLRequest(url: loadUrl), completionHandler: { data, response, error in
                    
                    guard let responseData = data, error == nil else {
                        completion(.failure(error ?? NSError(domain: "Bad request", code: 1, userInfo: nil)))
                        return
                    }
                    
                    if let users = try? JSONDecoder().decode([User].self, from: responseData) {
                        completion(.success(users))
                    } else {
                        completion(.failure(NSError(domain: "Parse error", code: 1, userInfo: nil)))
                    }
                })
                task.resume()
            }
        }
    }
}

class InitViewController: UIViewController {
    
    var loader: UserListLoader
    
    var info: UILabel?
    
    init(url: String) {
        self.loader = UserListLoader(anUrl: url)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let frame = CGRect(x: 100, y: 100, width: 100, height: 50)
        info = UILabel(frame: frame)
        info?.text = "Loading..."
        view.addSubview(info!)
        loader.loadusers { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let users):
                DispatchQueue.main.async {
                    let notVerifiedUsersCount = users.filter({ $0.status == UserType.UserTypeNotVerified }).count
                    self.info?.text = "There're " + String(notVerifiedUsersCount) + "  not verified users"
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self.info?.text = error.localizedDescription
                    
                }
            }
        }
    }
}
    
    

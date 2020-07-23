//
//  EmployeeDetailViewController.swift
//  Employee Directory
//
//  Created by Joana Valadao on 2020-07-22.
//  Copyright © 2020 Joana Valadao. All rights reserved.
//

import UIKit

class EmployeeDetailViewController: UIViewController {
    var viewModel: EmployeeDetailViewModel!
    
    lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero)
        table.allowsSelection = false
        table.register(EmployeeDetailCell.self, forCellReuseIdentifier: "detailCell")
        table.register(EmployeeDetailPhotoCell.self, forCellReuseIdentifier: "photoCell")
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        
        return table
    }()
    
//    lazy var photoView: UIImageView = {
//        let view = UIImageView(frame: .zero)
//        view.image = UIImage(named: "person")
//        view.contentMode = .scaleAspectFill
//        view.clipsToBounds = true
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//
//    lazy var nameLabel: UILabel = {
//        let label = UILabel(frame: .zero)
//        label.text = "NAME"
//        label.font = UIFont.systemFont(ofSize: 17.0)
//        label.lineBreakMode = .byWordWrapping
//        label.numberOfLines = 0
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    lazy var phoneLabel: UILabel = {
//        let label = UILabel(frame: .zero)
//        label.text = "1234567879"
//        label.font = UIFont.systemFont(ofSize: 17.0)
//        label.lineBreakMode = .byWordWrapping
//        label.numberOfLines = 0
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    lazy var emailLabel: UILabel = {
//        let label = UILabel(frame: .zero)
//        label.text = "EMAIL"
//        label.font = UIFont.systemFont(ofSize: 17.0)
//        label.lineBreakMode = .byWordWrapping
//        label.numberOfLines = 0
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    lazy var teamLabel: UILabel = {
//        let label = UILabel(frame: .zero)
//        label.text = "TEAM"
//        label.font = UIFont.systemFont(ofSize: 13.0)
//        label.lineBreakMode = .byWordWrapping
//        label.numberOfLines = 0
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    lazy var typeLabel: UILabel = {
//        let label = UILabel(frame: .zero)
//        label.text = "FULL-TIME"
//        label.font = UIFont.systemFont(ofSize: 13.0)
//        label.lineBreakMode = .byWordWrapping
//        label.numberOfLines = 0
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    lazy var biographyLabel: UITextView = {
//        let textView = UITextView(frame: .zero)
//        textView.text = "BIOGRAPHY"
//        textView.font = UIFont.systemFont(ofSize: 13.0)
//        textView.isEditable = false
//        textView.translatesAutoresizingMaskIntoConstraints = false
//        return textView
//    }()
    
    required init(employee: Employee) {
        super.init(nibName: nil, bundle: nil)
        viewModel = EmployeeDetailViewModel(employee)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

private extension EmployeeDetailViewController {
    func setupView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16.0),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 16.0),
            tableView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            tableView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8)
        ])
    }
}

extension EmployeeDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "photoCell", for: indexPath) as? EmployeeDetailPhotoCell else {
                return UITableViewCell(frame: .zero)
            }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as? EmployeeDetailCell else {
                return UITableViewCell(frame: .zero)
            }
            return cell
        }
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let imageView = UIImageView(frame: .zero) //(frame: CGRect(x: 0, y: 0, width: 0, height: 150))
//        imageView.contentMode = .scaleAspectFill
//        imageView.clipsToBounds = true
//        imageView.image = UIImage(named: "person")
//
//        let imageSize: CGFloat = min(view.safeAreaLayoutGuide.layoutFrame.width, view.safeAreaLayoutGuide.layoutFrame.height) * 0.8
//
//        NSLayoutConstraint.activate([
//            imageView.widthAnchor.constraint(equalToConstant: imageSize),
//            imageView.heightAnchor.constraint(equalToConstant: imageSize)
//        ])
//
//        return imageView
//    }
    
}


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
    
    required init(employee: Employee) {
        super.init(nibName: nil, bundle: nil)
        viewModel = EmployeeDetailViewModel(employee) { [unowned self] in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        setupView()
    }
}

private extension EmployeeDetailViewController {
    func setupView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16.0),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16.0),
            tableView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            tableView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8)
        ])
    }
}

extension EmployeeDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "photoCell", for: indexPath) as? EmployeeDetailPhotoCell else {
                return UITableViewCell(frame: .zero)
            }
            cell.photoImage.image = viewModel.getImage()
            return cell
        } else if indexPath.row == 1 {
            return UITableViewCell(frame: .zero)
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as? EmployeeDetailCell else {
                return UITableViewCell(frame: .zero)
            }
            cell.iconImage.image = viewModel.getIcon(for: indexPath)
            cell.infoLabel.text = viewModel.getInformation(for: indexPath)
            cell.infoLabel.textColor = viewModel.getColor(for: indexPath)
            cell.infoLabel.font = viewModel.getFont(for: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            let size = max(tableView.frame.height, tableView.frame.width)
            return size * 0.4
        case 1: return 20
        default: return 60
        }
    }
}


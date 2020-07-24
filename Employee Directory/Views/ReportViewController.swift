//
//  ReportViewController.swift
//  Employee Directory
//
//  Created by Joana Valadao on 2020-07-23.
//  Copyright © 2020 Joana Valadao. All rights reserved.
//

import UIKit

class ReportViewController: UIViewController {
    
    var viewModel: ReportViewModel!
    
    lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero)
        table.allowsSelection = false
        table.register(ReportViewCell.self, forCellReuseIdentifier: "reportCell")
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        
        return table
    }()
    
    required init(reportsData: [ChartData]) {
        super.init(nibName: nil, bundle: nil)
        viewModel = ReportViewModel(reportsData: reportsData)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

private extension ReportViewController {
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

extension ReportViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "reportCell", for: indexPath) as? ReportViewCell else {
            return UITableViewCell(frame: .zero)
        }
        cell.setCellData(for: viewModel.getReportData(for: indexPath))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.getHeaderTitle(for: section)
    }
    
    
}

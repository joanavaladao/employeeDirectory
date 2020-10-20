//
//  ViewController.swift
//  Employee Directory
//
//  Created by Joana Valadao on 2020-07-18.
//  Copyright © 2020 Joana Valadao. All rights reserved.
//

import UIKit

class EmployeeListViewController: UIViewController {

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(EmployeeListCell.self, forCellWithReuseIdentifier: "cell")
        collection.delegate = self
        collection.dataSource = self
        return collection
    }()
    
    lazy var searchBar: UISearchBar = {
        let bar = UISearchBar(frame: .zero)
        bar.barStyle = .default
        bar.delegate = self
        bar.showsCancelButton = true
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()
    
    private var viewModel: EmployeeListViewModel!
    
    required init() {
        super.init(nibName: nil, bundle: nil)
        viewModel = EmployeeListViewModel { [unowned self] in
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBars()
        setupView()
        viewModel.loadInitialInformation()
    }
}

private extension EmployeeListViewController {
    func setupBars() {
        navigationItem.title = "Employee Directory"
        
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshEmployeeList))
        let sortButton = UIBarButtonItem(image: UIImage(named: "settings"), style: .plain, target: self, action: #selector(sortBy))
        let reportButton = UIBarButtonItem(image: UIImage(named: "report"), style: .plain, target: self, action: #selector(goToReport))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        setToolbarItems([refreshButton, spacer, reportButton, spacer, sortButton], animated: true)
        navigationController?.setToolbarHidden(false, animated: true)
    }
    
    func setupView() {
        view.backgroundColor = .white
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        
        navigationController?.setToolbarHidden(false, animated: true)
        collectionView.backgroundColor = .gray
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.bottomAnchor.constraint(equalTo: collectionView.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    @objc func refreshEmployeeList() {
        viewModel.refreshEmployeeList { result in
            switch result {
            case .success(let _):
                self.collectionView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc func sortBy(_ sender: UIBarButtonItem){
        let alert = UIAlertController(title: "Sort by:", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Name", style: .default) { _ in
            self.viewModel.sortBy(.name)
        })
        alert.addAction(UIAlertAction(title: "Team", style: .default) { _ in
            self.viewModel.sortBy(.team)
        })
        present(alert, animated: true)
    }
    
    @objc func goToReport() {
        let viewController = ReportViewController(reportsData: viewModel.reportData())
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension EmployeeListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? EmployeeListCell else {
            return UICollectionViewCell()
        }
        cell.nameLabel.text = viewModel.getName(for: indexPath)
        cell.teamLabel.text = viewModel.getTeam(for: indexPath)
        cell.photoView.image = viewModel.getImage(for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 155.0, height: 230.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        searchBar.resignFirstResponder()
        let viewController = EmployeeDetailViewController(employee: viewModel.getEmployee(for: indexPath))
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension EmployeeListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filter(by: searchText)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

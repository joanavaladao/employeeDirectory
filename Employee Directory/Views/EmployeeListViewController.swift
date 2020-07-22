//
//  ViewController.swift
//  Employee Directory
//
//  Created by Joana Valadao on 2020-07-18.
//  Copyright © 2020 Joana Valadao. All rights reserved.
//

import UIKit
import CoreData

var appDelegate: AppDelegate?
var context: NSManagedObjectContext?

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
    
    lazy var navigationBar: UINavigationBar = {
        let bar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        let item = UINavigationItem(title: "Employee Directory")
        item.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: nil, action: #selector(refreshEmployeeList))
        item.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "settings"), style: .plain, target: nil, action: #selector(sortBy))
        bar.setItems([item], animated: true)
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()
    
    lazy var searchBar: UISearchBar = {
        let bar = UISearchBar(frame: .zero)
        bar.barStyle = .default
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
        setupView()
        viewModel.loadInitialInformation()
    }
}

private extension EmployeeListViewController {
    func setupView() {
        view.backgroundColor = .white
        view.addSubview(navigationBar)
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        collectionView.backgroundColor = .gray
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            searchBar.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            searchBar.bottomAnchor.constraint(equalTo: collectionView.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
//            collectionView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    @objc func refreshEmployeeList() {
        viewModel.refreshEmployeeList()
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
    
}

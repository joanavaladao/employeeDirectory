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
        item.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: nil, action: #selector(refresh))
        bar.setItems([item], animated: true)
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()
    
    private let viewModel: EmployeeListViewModel = EmployeeListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

private extension EmployeeListViewController {
    func setupView() {
        view.backgroundColor = .white
        view.addSubview(navigationBar)
        view.addSubview(collectionView)
        collectionView.backgroundColor = .gray
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            collectionView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    @objc func refresh() {
        
    }
}

extension EmployeeListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 11
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 155.0, height: 230.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
}

extension EmployeeListViewController: DownloadDelegate {
    func savedTemporaryFile(at url: URL, downloadType: DownloadType) {
        switch downloadType {
        case .list:
//            loadEmployeeList()
//            downloadSmallImages()
            print("list")
        case .smallImage:
            print("small")
        case .largeImage:
            print("large")
        }
    }
    
    func errorDownloadingFile(_ error: Error, downloadType: DownloadType){}
    func errorSavingFile(_ error: Error, downloadType: DownloadType){}
}

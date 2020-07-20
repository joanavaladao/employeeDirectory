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
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collection.delegate = self
        collection.dataSource = self
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

private extension EmployeeListViewController {
    func setupView() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.backgroundColor = .gray
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

extension EmployeeListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 11
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .yellow
        return cell
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

//
//  EmployeeListViewModel.swift
//  Employee Directory
//
//  Created by Joana Valadao on 2020-07-19.
//  Copyright © 2020 Joana Valadao. All rights reserved.
//

import UIKit
import CoreData

enum SortBy: String {
    case name = "name"
    case team = "team"
}

class EmployeeListViewModel {
    
    private var fullEmployeeList: [Employee] = []
    private var filteredEmployeeList: [Employee] = []
    private var downloadService: DownloadService?
    private var defaults: UserDefaults
    private var dataChanged: () -> Void
    private var fileService: FileService
    
    init(fileService: FileService = FileService(), defaults: UserDefaults = UserDefaults.standard, dataChanged: @escaping () -> Void) {
        DispatchQueue.main.async {
            appDelegate = UIApplication.shared.delegate as? AppDelegate
            context = appDelegate?.persistentContainer.viewContext
        }
        self.dataChanged = dataChanged
        self.fileService = fileService
        self.defaults = defaults
    }
    
    func loadInitialInformation() {
        loadSavedEmployees()
        if (fullEmployeeList.count == 0) {
            loadEmployees(from: EmployeeListURL.emptyList.rawValue)
        }
    }
    
    func refreshEmployeeList() {
        loadEmployees()
    }
    
    func numberOfItems() -> Int {
        return filteredEmployeeList.count
    }
    
    func getName(for index: IndexPath) -> String {
        return filteredEmployeeList[index.row].fullName
    }
    
    func getTeam(for index: IndexPath) -> String {
        return filteredEmployeeList[index.row].team
    }
    
    func getImage(for index: IndexPath) -> UIImage {
        let placeHolder: UIImage = UIImage(named: "person") ?? UIImage()
        
        guard let filename = filteredEmployeeList[index.row].photoSmallDisk else {
            return placeHolder
        }
        let imageURL = fileService.smallImagesFolder.appendingPathComponent(filename)
        return UIImage(contentsOfFile: imageURL.path) ?? placeHolder
    }
    
    func sortBy(_ type: SortBy? = nil) {
        var sort: SortBy
        if let type = type {
            sort = type
        } else {
            sort = SortBy(rawValue: defaults.string(forKey: "sortBy") ?? "name") ?? .name
        }
        
        switch sort {
        case .name:
            defaults.set("name", forKey: "sortBy")
            filteredEmployeeList.sort { $0.fullName < $1.fullName}
        case .team:
            defaults.set("team", forKey: "sortBy")
            filteredEmployeeList.sort { $0.team < $1.team}
        }
        dataChanged()
    }
    
    func filter(by searchText: String) {
        filteredEmployeeList.removeAll()
        guard !searchText.isEmpty else {
            filteredEmployeeList = fullEmployeeList
            sortBy()
            dataChanged()
            return
        }
        
        filteredEmployeeList = fullEmployeeList.filter {
            $0.fullName.uppercased().starts(with: searchText.uppercased()) || $0.team.uppercased().starts(with: searchText.uppercased())
        }
        sortBy()
        dataChanged()
    }
    
    func getEmployee(for index: IndexPath) -> Employee {
        return filteredEmployeeList[index.row]
    }
}

private extension EmployeeListViewModel {
    func downloadSmallImages() {
        guard fullEmployeeList.count > 0,
            let appDelegate = appDelegate else {
            return
        }
        
        let downloadService = self.downloadService ?? DownloadService(delegate: self)
        
        for employee in fullEmployeeList {
            guard employee.shouldDownloadSmallImage() else { return }
            let diskPath: String = employee.photoSmallDisk ?? ""
            if !diskPath.isEmpty {
                fileService.removeFile(at: diskPath)
                employee.photoSmallDisk = nil
            }
            employee.photoSmallURL = employee.photoSmallNewURL
            
            
            guard let newDiskPath = employee.photoSmallURL else {
                return
            }
            let filename = "\(employee.uuid)-\(URL(fileURLWithPath: newDiskPath).lastPathComponent)"
            employee.photoSmallDisk = filename
            appDelegate.saveContext()
            
            downloadService.startDownload(of: .smallImage, from: newDiskPath, filename: filename)
        }
    }
    
    // Read from coredata
    func loadSavedEmployees() {
        guard let context = context else {
            return
        }
        
        fullEmployeeList.removeAll()
        filteredEmployeeList.removeAll()
        
        do {
            fullEmployeeList = try context.fetch(Employee.fetchRequest())
            filteredEmployeeList = fullEmployeeList
            let sort = SortBy(rawValue: defaults.string(forKey: "sortBy") ?? "name") ?? .name
            sortBy(sort)
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func loadEmployees(from path: String = EmployeeListURL.fullList.rawValue) {
        let downloadService = self.downloadService ?? DownloadService(delegate: self)
        downloadService.startDownload(of: .list, from: path)
    }
}

extension EmployeeListViewModel: DownloadDelegate {
    func savedTemporaryFile(at url: URL, downloadType: DownloadType) {
        switch downloadType {
        case .list:
            loadSavedEmployees()
            downloadSmallImages()
            dataChanged()
            print("list")
        case .smallImage:
            dataChanged()
        case .largeImage:
            print("large")
        }
    }
    
    func errorDownloadingFile(_ error: Error, downloadType: DownloadType){}
    func errorSavingFile(_ error: Error, downloadType: DownloadType){}
}

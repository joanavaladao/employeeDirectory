//
//  EmployeeListViewModel.swift
//  Employee Directory
//
//  Created by Joana Valadao on 2020-07-19.
//  Copyright © 2020 Joana Valadao. All rights reserved.
//

import UIKit
import CoreData

class EmployeeListViewModel {
    
    private var fullEmployeeList: [Employee] = []
    private var filteredEmployeeList: [Employee] = []
    private var downloadService: DownloadService
    private var defaults: UserDefaults
    private var dataChanged: () -> Void
//    private var handleError: (DownloadErrors) -> Void
    private var fileService: FileService
    private var employees: ManageEmployee
    
    init(fileService: FileService = FileService(),
         defaults: UserDefaults = UserDefaults.standard,
         employeeManager: ManageEmployee = ManageEmployee(),
         downloadService: DownloadService = DownloadService(),
         dataChanged: @escaping () -> Void) {
//        DispatchQueue.main.async {
//            appDelegate = UIApplication.shared.delegate as? AppDelegate
//            context = appDelegate?.persistentContainer.viewContext
//        }
        self.dataChanged = dataChanged
//        self.handleError =
        self.fileService = fileService
        self.defaults = defaults
        employees = employeeManager
        self.downloadService = downloadService
    }
    
    func loadInitialInformation() {
//        loadSavedEmployees()
//        if (fullEmployeeList.count == 0) {
//            loadEmployees(from: EmployeeListURL.emptyList.rawValue)
//        }
    }
    
    func refreshEmployeeList(path: String = EmployeeListURL.fullList.rawValue, completionHandler: @escaping (Result<String?, Error>) -> Void) {
        downloadService.startDownload(from: path) { result in
            switch result {
            case .success(let newPath):
                self.employees.loadEmployees(from: newPath)
                completionHandler(.success(nil))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    
//    switch self.downloadType {
//    case .list:
//
//        switch status {
//        case .success(let url):
//            self.fileService.persistEmployeeList(file: url)
//            self.delegate.savedTemporaryFile(at: url, downloadType: .list)
//        case .failure(let error):
//            self.delegate.errorSavingFile(error, downloadType: self.downloadType)
//        }
//    default:
//        guard let filename = filename else {
//            return
//        }
//        let destinyURL: URL = self.downloadType == .largeImage ? self.fileService.largeImagesFolder : self.fileService.smallImagesFolder
//        let imageURL = destinyURL.appendingPathComponent(filename)
//
//        let status = self.fileService.saveFile(from: url, to: imageURL.path)
//        switch status {
//        case .success(_):
//            self.delegate.savedTemporaryFile(at: url, downloadType: self.downloadType)
//        case .failure(let error):
//            self.delegate.errorSavingFile(error, downloadType: self.downloadType)
//        }
//    }
    
    func numberOfItems() -> Int {
        return employees.numberOf()
    }
    
    func getName(for index: IndexPath) -> String {
//        return filteredEmployeeList[index.row].fullName
        return employees.employee(at: index).fullName ?? ""
    }
    
    func getTeam(for index: IndexPath) -> String {
//        return filteredEmployeeList[index.row].team
        return employees.employee(at: index).team ?? ""
    }
    
    func getImage(for index: IndexPath) -> UIImage {
        let placeHolder: UIImage = UIImage(named: "person") ?? UIImage()
//
//        guard let filename = filteredEmployeeList[index.row].photoSmallDisk else {
//            return placeHolder
//        }
//        let imageURL = fileService.smallImagesFolder.appendingPathComponent(filename)
//        return UIImage(contentsOfFile: imageURL.path) ?? placeHolder
        return placeHolder
    }
    
    func sortBy(_ type: SortBy? = nil) {
//        var sort: SortBy
//        if let type = type {
//            sort = type
//        } else {
//            sort = SortBy(rawValue: defaults.string(forKey: "sortBy") ?? "name") ?? .name
//        }
//
//        switch sort {
//        case .name:
//            defaults.set("name", forKey: "sortBy")
//            filteredEmployeeList.sort { $0.fullName < $1.fullName}
//        case .team:
//            defaults.set("team", forKey: "sortBy")
//            filteredEmployeeList.sort { $0.team < $1.team}
//        }
//        dataChanged()
    }
    
    func filter(by searchText: String) {
//        filteredEmployeeList.removeAll()
//        guard !searchText.isEmpty else {
//            filteredEmployeeList = fullEmployeeList
//            sortBy()
//            dataChanged()
//            return
//        }
//
//        filteredEmployeeList = fullEmployeeList.filter {
//            $0.fullName.uppercased().starts(with: searchText.uppercased()) || $0.team.uppercased().starts(with: searchText.uppercased())
//        }
//        sortBy()
//        dataChanged()
    }
    
    func getEmployee(for index: IndexPath) -> Employee {
        return employees.employee(at: index)
    }
    
    func reportData() -> [ChartData] {
//        guard fullEmployeeList.count > 0 else {
//            return []
//        }
//
//        var fullTime = 0
//        var partTime = 0
//        var contract = 0
//        var unknown = 0
//
//        for employee in fullEmployeeList {
//            if let type = EmployeeType(rawValue: employee.employeeType) {
//                switch type {
//                case .fullTime: fullTime += 1
//                case .partTime: partTime += 1
//                case .contractor: contract += 1
//                }
//            } else {
//                unknown += 1
//            }
//        }
//
//        return [ChartData(title: "Employment Type", data: [Information(description: "Full Time", value: fullTime), Information(description: "Part Time", value: partTime), Information(description: "Contractor", value: contract), Information(description: "Unknown", value: unknown)])]
        return []
    }
}

private extension EmployeeListViewModel {
    func downloadSmallImages() {
//        guard fullEmployeeList.count > 0,
//            let appDelegate = appDelegate else {
//            return
//        }
//
//        let downloadService = self.downloadService ?? DownloadService(delegate: self)
//
//        for employee in fullEmployeeList {
//            guard employee.shouldDownloadSmallImage() else { return }
//            let diskPath: String = employee.photoSmallDisk ?? ""
//            if !diskPath.isEmpty {
//                fileService.removeFile(at: diskPath)
//                employee.photoSmallDisk = nil
//            }
//            employee.photoSmallURL = employee.photoSmallNewURL
//
//
//            guard let newDiskPath = employee.photoSmallURL else {
//                return
//            }
//            let filename = "\(employee.uuid)-\(URL(fileURLWithPath: newDiskPath).lastPathComponent)"
//            employee.photoSmallDisk = filename
//            appDelegate.saveContext()
//
//            downloadService.startDownload(of: .smallImage, from: newDiskPath, filename: filename)
//        }
    }
    
    // Read from coredata
    func loadSavedEmployees() {
//        employees.
//        guard let context = context else {
//            return
//        }
//
//        fullEmployeeList.removeAll()
//        filteredEmployeeList.removeAll()
//
//        do {
//            fullEmployeeList = try context.fetch(Employee.fetchRequest())
//            filteredEmployeeList = fullEmployeeList
//            let sort = SortBy(rawValue: defaults.string(forKey: "sortBy") ?? "name") ?? .name
//            sortBy(sort)
//        } catch let error as NSError {
//          print("Could not fetch. \(error), \(error.userInfo)")
//        }
    }
}

extension EmployeeListViewModel: DownloadDelegate {
    func savedTemporaryFile(at url: URL, downloadType: DownloadType) {
//        switch downloadType {
//        case .list:
//            loadSavedEmployees()
//            downloadSmallImages()
//            dataChanged()
//            print("list")
//        case .smallImage:
//            dataChanged()
//        case .largeImage:
//            print("large")
//        }
    }
    
    func errorDownloadingFile(_ error: Error, downloadType: DownloadType){}
    func errorSavingFile(_ error: Error, downloadType: DownloadType){}
}

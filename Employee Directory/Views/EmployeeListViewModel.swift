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
    
    private var employeeList: [Employee] = []
    private var downloadService: DownloadService?
    private var dataChanged: () -> Void
    private var fileService: FileService
    
    init(fileService: FileService = FileService(), dataChanged: @escaping () -> Void) {
        DispatchQueue.main.async {
            appDelegate = UIApplication.shared.delegate as? AppDelegate
            context = appDelegate?.persistentContainer.viewContext
        }
        self.dataChanged = dataChanged
        self.fileService = fileService
    }
    
    func loadInitialInformation() {
        loadSavedEmployees()
        if (employeeList.count == 0) {
            loadEmployees()
        }
    }
    
    func numberOfItems() -> Int {
        return employeeList.count
    }
    
    func getName(for index: IndexPath) -> String {
        return employeeList[index.row].fullName
    }
    
    func getTeam(for index: IndexPath) -> String {
        return employeeList[index.row].team
    }
    
    func getImage(for index: IndexPath) -> UIImage {
        let placeHolder: UIImage = UIImage(named: "person") ?? UIImage()
        
        guard let filename = employeeList[index.row].photoSmallDisk else {
            return placeHolder
        }
        let imageURL = fileService.smallImagesFolder.appendingPathComponent(filename)
        return UIImage(contentsOfFile: imageURL.path) ?? placeHolder
    }
    
}

private extension EmployeeListViewModel {
    func downloadSmallImages() {
        guard employeeList.count > 0,
            let appDelegate = appDelegate else {
            return
        }
        
        let downloadService = self.downloadService ?? DownloadService(delegate: self)
        
        for employee in employeeList {
            guard employee.shouldDownloadSmallImage() else { return }
            let diskPath: String = employee.photoSmallDisk ?? ""
            if !diskPath.isEmpty {
                fileService.removeFile(at: diskPath)
                employee.photoSmallDisk = nil
            }
            employee.photoSmallURL = employee.photoSmallNewURL
            
            
            guard let newDiskPath = employee.photoSmallURL else {
                // TODO: erro?
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
        
        employeeList.removeAll()
        
        do {
          employeeList = try context.fetch(Employee.fetchRequest())
            print(employeeList)
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

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
    private var downloadService: DownloadService
    
    init(downloadDelegate: DownloadDelegate) {
        DispatchQueue.main.async {
            appDelegate = UIApplication.shared.delegate as? AppDelegate
            context = appDelegate?.persistentContainer.viewContext
        }
        downloadService = DownloadService(delegate: downloadDelegate)
    }
    
    
}

private extension EmployeeListViewModel {
    func downloadSmallImages(fileService: FileService = FileService()) {
        guard employeeList.count > 0,
            let appDelegate = appDelegate else {
            return
        }
        
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
            let filename = URL(fileURLWithPath: newDiskPath).lastPathComponent
            let destiny = fileService.smallImagesFolder.appendingPathComponent("\(employee.uuid)-\(filename)")
            employee.photoSmallDisk = destiny.path
            appDelegate.saveContext()
            
            downloadService.startDownload(of: .smallImage, from: newDiskPath, to: destiny.path)
        }
    }
    
    func loadEmployeeList() {
        guard let context = context else {
            return
        }
        
        do {
          employeeList = try context.fetch(Employee.fetchRequest())
            print(employeeList)
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}

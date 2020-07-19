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

class ViewController: UIViewController {

    lazy var downloadService: DownloadService = {
        return DownloadService(delegate: self)
    }()
    
    var employeeList: [Employee] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        DispatchQueue.main.async {
            appDelegate = UIApplication.shared.delegate as? AppDelegate
            context = appDelegate?.persistentContainer.viewContext
        }
    }

    @IBAction func read(_ sender: UIButton) {
        print("****** Button pressed")
        downloadService.startDownload(of: .list, from: EmployeeList.fullList.rawValue)
    }
    
    @IBAction func show(_ sender: UIButton) {
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
    
    func downloadSmallImages(fileService: FileService = FileService()) {
        guard employeeList.count > 0,
            let appDelegate = appDelegate else {
            return
        }
        
        for employee in employeeList {
            guard employee.shouldDownloadSmallImage() else { return }
            if !employee.photoSmallDisk.isEmpty {
                fileService.removeFile(at: employee.photoSmallDisk)
                employee.photoSmallDisk = nil
            }
            employee.photoSmallURL = employee.photoSmallNewURL
            appDelegate.saveContext()
            
            downloadService.startDownload(of: .smallImage, from: employee.photoSmallURL)
        }
    }
}

extension ViewController: DownloadDelegate {
    func savedTemporaryFile(at url: URL, downloadType: DownloadType) {
        switch downloadType {
        case .list:
            shouldDownloadSmallImages()
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

//
//  FileService.swift
//  Employee Directory
//
//  Created by Joana Valadao on 2020-07-18.
//  Copyright © 2020 Joana Valadao. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class FileService {
    lazy var rootFolder: URL = {
        return fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    }()
    
    lazy var temporaryFolder: URL = {
        return rootFolder.appendingPathComponent("temp")
    }()
    
    lazy var largeImagesFolder: URL = {
        return rootFolder.appendingPathComponent("largeImages")
    }()
    
    lazy var smallImagesFolder: URL = {
        return rootFolder.appendingPathComponent("smallImages")
    }()
    
    var fileManager: FileManager
    
    init(fileManager: FileManager = FileManager.default) {
        self.fileManager = fileManager
    }
    
    func createDirectories() {
        do {
            if !fileManager.fileExists(atPath: temporaryFolder.path) {
                try fileManager.createDirectory(at: temporaryFolder, withIntermediateDirectories: true, attributes: nil)
            }
            
            if !fileManager.fileExists(atPath: largeImagesFolder.path) {
                try fileManager.createDirectory(at: largeImagesFolder, withIntermediateDirectories: true, attributes: nil)
            }
            
            if !fileManager.fileExists(atPath: smallImagesFolder.path) {
                try fileManager.createDirectory(at: smallImagesFolder, withIntermediateDirectories: true, attributes: nil)
            }
        } catch (let error) {
            //TODO handle error
            print(error)
        }
    }
    
    func saveTemporaryFile(from path: URL, filename: String) -> Result<URL, Error> {
        let destinationURL: URL = temporaryFolder.appendingPathComponent(filename)
        return saveFile(from: path, to: destinationURL.path)
    }
    
    func saveFile(from path: URL, to destinyPath: String) -> Result<URL, Error> {
        let destinyURL = URL(fileURLWithPath: destinyPath)
        
        do {
            try? fileManager.removeItem(at: destinyURL)
            try fileManager.copyItem(at: path, to: destinyURL)
            return .success(destinyURL)
        } catch let error {
            return .failure(error)
        }
    }
    
    func persistEmployeeList(file: URL,
                             appDelegate: AppDelegate? = appDelegate,
                             context: NSManagedObjectContext? = context) {
        guard let appDelegate = appDelegate,
            let context = context else {
                return
        }
        
        let decoder = JSONDecoder()

        do {
            let employeesData = try Data(contentsOf: file)
            let employeesListJSON = try decoder.decode(EmployeeJSONList.self, from: employeesData)
            for employeeJSON in employeesListJSON.employees {
                _ = Employee(employeeJSON, context: context)
            }
            if employeesListJSON.employees.count > 0 {
                context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
                appDelegate.saveContext()
            }
        } catch let error {
            print(error)
        }
    }
    
    func checkIfFileExists(path: String) -> Bool {
        return fileManager.fileExists(atPath: path)
    }
    
    func removeFile(at path: String) {
        try? fileManager.removeItem(atPath: path)
    }
}

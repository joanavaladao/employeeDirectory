//
//  FileService.swift
//  Employee Directory
//
//  Created by Joana Valadao on 2020-07-18.
//  Copyright © 2020 Joana Valadao. All rights reserved.
//

import Foundation

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
    
    func saveTemporaryFile(from path: URL, filename: String) -> Result<URL, Error> {
        let destinationURL: URL = temporaryFolder.appendingPathComponent(filename)
        do {
            try fileManager.removeItem(at: destinationURL)
            try fileManager.copyItem(at: path, to: destinationURL)
            return .success(destinationURL)
        } catch let error {
            return .failure(error)
        }
    }
    
    func saveList(file: URL) {
        Employee
    }
}

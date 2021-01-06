//
//  Employee+CoreDataClass.swift
//  Employee Directory
//
//  Created by Joana Valadao on 05/10/20.
//  Copyright © 2020 Joana Valadao. All rights reserved.
//
//

import UIKit
import CoreData


public class Employee: NSManagedObject {
    func hasLargeImage() -> Bool {
        guard let path = photoLargeURL,
            photoLargeDownloadedURL == path,
            photoLarge != nil else {
            return false
        }
        return true
    }
    
    func downloadLargeImage(downloadService: DownloadService = DownloadService(),
                            completionHandler: @escaping (Result<Void, DownloadErrors>)->Void) {
        guard let path = photoLargeURL else {
            completionHandler(.failure(.noOriginURL))
            return
        }
        
        downloadService.startDownload(from: path) { result in
            switch result {
            case .success(let newPath):
                self.photoLargeDownloadedURL = path
                self.photoLarge = UIImage(contentsOfFile: newPath)?.pngData() as Data?
                appDelegate.saveContext()
                completionHandler(.success(()))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}

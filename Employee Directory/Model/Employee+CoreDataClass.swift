//
//  Employee+CoreDataClass.swift
//  Employee Directory
//
//  Created by Joana Valadao on 05/10/20.
//  Copyright © 2020 Joana Valadao. All rights reserved.
//
//

import Foundation
import CoreData


public class Employee: NSManagedObject {
    
    func shouldDownloadSmallImage(fileService: FileService = FileService()) -> Bool {
        return photoSmall == nil
    }
    
    func shouldDownloadLargeImage(fileService: FileService = FileService()) -> Bool {
        return photoLarge == nil
    }
}

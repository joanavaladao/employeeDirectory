//
//  Employee.swift
//  Employee Directory
//
//  Created by Joana Valadao on 2020-07-19.
//  Copyright © 2020 Joana Valadao. All rights reserved.
//

import Foundation
import CoreData

public class Employee: NSManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Employee> {
        return NSFetchRequest<Employee>(entityName: "Employee")
    }
    
    @nonobjc public class func fetchRequest(uuid: String) -> NSFetchRequest<Employee> {
        let request = NSFetchRequest<Employee>(entityName: "Employee")
        let predicate = NSPredicate(format: "uuid=%@", uuid)
        request.predicate = predicate
        
        return request
    }

    @NSManaged public var uuid: String
    @NSManaged public var fullName: String
    @NSManaged public var phoneNumber: String?
    @NSManaged public var email: String
    @NSManaged public var biography: String?
    @NSManaged public var photoSmallURL: String?
    @NSManaged public var photoSmallDisk: String?
    @NSManaged public var photoSmallNewURL: String?
    @NSManaged public var photoLargeURL: String?
    @NSManaged public var photoLargeDisk: String?
    @NSManaged public var photoLargeNewURL: String?
    @NSManaged public var team: String
    @NSManaged public var employeeType: String
}

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

    @NSManaged public var uuid: String
    @NSManaged public var fullName: String
    @NSManaged public var phoneNumber: String?
    @NSManaged public var email: String
    @NSManaged public var biography: String?
    @NSManaged public var photoSmallURL: String?
    @NSManaged public var photoSmallDisk: String?
    @NSManaged public var photoLargeURL: String?
    @NSManaged public var photoLargeDisk: String?
    @NSManaged public var team: String
    @NSManaged public var employeeType: String
}

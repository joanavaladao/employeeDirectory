//
//  Employee+CoreDataProperties.swift
//  Employee Directory
//
//  Created by Joana Valadao on 07/12/20.
//  Copyright © 2020 Joana Valadao. All rights reserved.
//
//

import Foundation
import CoreData


extension Employee {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Employee> {
        return NSFetchRequest<Employee>(entityName: "Employee")
    }

    @NSManaged public var biography: String?
    @NSManaged public var email: String?
    @NSManaged public var employeeType: String?
    @NSManaged public var fullName: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var photoLarge: Data?
    @NSManaged public var photoLargeURL: String?
    @NSManaged public var photoSmall: Data?
    @NSManaged public var photoSmallURL: String?
    @NSManaged public var team: String?
    @NSManaged public var uuid: String?
    @NSManaged public var photoLargeDownloadedURL: String?
    @NSManaged public var photoSmallDownloadedURL: String?

}

//
//  Employee+Functions.swift
//  Employee Directory
//
//  Created by Joana Valadao on 2020-07-19.
//  Copyright © 2020 Joana Valadao. All rights reserved.
//

import Foundation
import CoreData

struct EmployeeJSON: Codable {
    var uuid: String
    var full_name: String
    var phone_number: String
    var email_address: String
    var biography: String
    var photo_url_small: String
    var photo_url_large: String
    var team: String
    var employee_type: String
}

struct EmployeeJSONList: Codable {
    var employees: [EmployeeJSON]
}

enum EmployeeType: String {
    case fullTime = "FULL_TIME"
    case partTime = "PART_TIME"
    case contractor = "CONTRACTOR"
}

extension Employee {
    convenience init (_ employeeJSON: EmployeeJSON, context: NSManagedObjectContext) {
        self.init(entity: Employee.entity(), insertInto: context)
        self.uuid = employeeJSON.uuid
        self.fullName = employeeJSON.full_name
        self.phoneNumber = employeeJSON.phone_number
        self.email = employeeJSON.email_address
        self.biography = employeeJSON.biography
        self.photoSmallURL = employeeJSON.photo_url_small
        self.photoLargeURL = employeeJSON.photo_url_large
        self.team = employeeJSON.team
        self.employeeType = employeeJSON.employee_type.uppercased()
    }
}

//
//  ManageEmployee.swift
//  Employee Directory
//
//  Created by Joana Valadao on 08/10/20.
//  Copyright © 2020 Joana Valadao. All rights reserved.
//

import Foundation
import CoreData

enum SortBy {
    case name
    case team
    
    var sortDescriptor: NSSortDescriptor {
        switch self {
        case .name:
            return NSSortDescriptor(key: #keyPath(Employee.fullName), ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))
        case .team:
            return NSSortDescriptor(key: #keyPath(Employee.team), ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))
        }
    }
}

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

enum EmployeeType: String {
    case fullTime = "FULL_TIME"
    case partTime = "PART_TIME"
    case contractor = "CONTRACTOR"
}

class ManageEmployee {
    private var fetchedRC: NSFetchedResultsController<Employee>!
    private var query: String = ""
    private var sort: SortBy = .name
    
    init() {
        refresh()
    }
    
    func loadEmployees(from path: String) {
        let decoder = JSONDecoder()

        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let employeesDict = try decoder.decode([String: [EmployeeJSON]].self, from: data)
            
            guard let employees = employeesDict["employees"] else {
                print("no employees")
                return
            }
            
            for employee in employees {
                let newEmployee = Employee(entity: Employee.entity(), insertInto: context)
                newEmployee.uuid = employee.uuid
                newEmployee.fullName = employee.full_name
                newEmployee.phoneNumber = employee.phone_number
                newEmployee.email = employee.email_address
                newEmployee.biography = employee.biography
                newEmployee.photoSmallURL = employee.photo_url_small
                newEmployee.photoLargeURL = employee.photo_url_large
                newEmployee.team = employee.team
                newEmployee.employeeType = employee.employee_type.uppercased()
            }
            try context.save()
            refresh()
        } catch let error {
            print("Error - \(error)")
        }
    }
    
    func employee(at indexPath: IndexPath) -> Employee {
        return fetchedRC.object(at: indexPath)
    }
    
    func numberOf() -> Int {
        return fetchedRC.fetchedObjects?.count ?? 0
    }
}

private extension ManageEmployee {
    func refresh() {
        let request = Employee.fetchRequest() as NSFetchRequest<Employee>
        if !query.isEmpty {
            request.predicate = NSPredicate(format: "fullName CONTAINS[cd] %@ OR team CONTAINS[cd] %@", query, query)
        }
        request.sortDescriptors = [sort.sortDescriptor]
        do {
            fetchedRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            try fetchedRC.performFetch()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}

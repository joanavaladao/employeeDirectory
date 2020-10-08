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
    
    func loadEmployees(from data: Data) {
        let decoder = JSONDecoder()

        do {
            let employeesDict = try decoder.decode([String: [EmployeeJSON]].self, from: data)
            //criar a funcao para ler o json e carregar os dados no coredata.
            //criar uma private function para criar o employee como o convenience init abaixo.
    }
        
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
    
    func employee(at indexPath: IndexPath) -> Employee {
        return fetchedRC.object(at: indexPath)
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

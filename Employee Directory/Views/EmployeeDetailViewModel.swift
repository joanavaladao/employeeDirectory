//
//  EmployeeDetailViewModel.swift
//  Employee Directory
//
//  Created by Joana Valadao on 2020-07-22.
//  Copyright © 2020 Joana Valadao. All rights reserved.
//

import Foundation

enum InformationType {
    case photo
    case name
    case phone
    case email
    case biography
    case team
    case type
    
    
}

class EmployeeDetailViewModel {
    var employee: Employee
    
    init(_ employee: Employee) {
        self.employee = employee
    }
    
}

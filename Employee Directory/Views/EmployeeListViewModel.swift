//
//  EmployeeListViewModel.swift
//  Employee Directory
//
//  Created by Joana Valadao on 2020-07-19.
//  Copyright © 2020 Joana Valadao. All rights reserved.
//

import UIKit
import CoreData

class EmployeeListViewModel {
    
    private var downloadService: DownloadService
    private var defaults: UserDefaults
    private var dataChanged: () -> Void
    private var fileService: FileService
    private var employees: ManageEmployee
    
    init(fileService: FileService = FileService(),
         defaults: UserDefaults = UserDefaults.standard,
         employeeManager: ManageEmployee = ManageEmployee(),
         downloadService: DownloadService = DownloadService(),
         dataChanged: @escaping () -> Void) {
        
        self.dataChanged = dataChanged
        self.fileService = fileService
        self.defaults = defaults
        employees = employeeManager
        self.downloadService = downloadService
    }
    
    func refreshEmployeeList(path: String = EmployeeListURL.fullList.rawValue, completionHandler: @escaping (Result<String?, Error>) -> Void) {
        downloadService.startDownload(from: path) { result in
            switch result {
            case .success(let newPath):
                self.employees.loadEmployees(from: newPath) { result in
                    switch result {
                    case .success(()):
                        self.dataChanged()
                    case .failure(let error):
                        print(error)
                    }
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }

    func numberOfItems() -> Int {
        return employees.numberOf()
    }
    
    func getName(for index: IndexPath) -> String {
        return employees.employee(at: index).fullName ?? ""
    }
    
    func getTeam(for index: IndexPath) -> String {
        return employees.employee(at: index).team ?? ""
    }
    
    func getImage(for index: IndexPath) -> UIImage {
        guard let image = employees.getSmallImage(employeeAt: index) else {
            return UIImage(named: "person") ?? UIImage()
        }
        return image
    }
    
    func sortBy(_ type: SortBy? = nil) {
        let sort: SortBy = type ?? .name
        employees.sortBy(type: sort) {
            dataChanged()
        }
    }
    
    func filter(by searchText: String) {
        employees.filterBy(condition: searchText) {
            dataChanged()
        }
    }
    
    func getEmployee(for index: IndexPath) -> Employee {
        return employees.employee(at: index)
    }
    
    func reportData() -> [ChartData] {
        guard let visibleEmployees = employees.filteredEmployees(),
            visibleEmployees.count > 0 else {
            return []
        }

        var fullTime = 0
        var partTime = 0
        var contract = 0
        var unknown = 0

        for employee in visibleEmployees {
            if let type = EmployeeType(rawValue: employee.employeeType ?? "") {
                switch type {
                case .fullTime: fullTime += 1
                case .partTime: partTime += 1
                case .contractor: contract += 1
                }
            } else {
                unknown += 1
            }
        }

        return [ChartData(title: "Employment Type", data: [Information(description: "Full Time", value: fullTime), Information(description: "Part Time", value: partTime), Information(description: "Contractor", value: contract), Information(description: "Unknown", value: unknown)])]
    }
}

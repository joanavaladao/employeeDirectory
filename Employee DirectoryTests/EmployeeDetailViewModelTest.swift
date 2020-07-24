//
//  EmployeeDetailViewModelTest.swift
//  Employee DirectoryTests
//
//  Created by Joana Valadao on 2020-07-23.
//  Copyright © 2020 Joana Valadao. All rights reserved.
//

import XCTest
import CoreData
@testable import Employee_Directory

class EmployeeDetailViewModelTest: XCTestCase {
    
    var sut: EmployeeDetailViewModel!

    override func setUpWithError() throws {
        super.setUp()
        let employee = MockEmployee()
        sut = EmployeeDetailViewModel(employee) {
            print("Data changed")
        }
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testNumberOfRows() throws {
        let numberOfRows = sut.numberOfRows()
        XCTAssertEqual(numberOfRows, 8, "Wrong number of rows to tableview.")
    }
    
    func testGetInformation() throws {
        for i in 0...7 {
            switch i {
            case 2:
                XCTAssertEqual(sut.getInformation(for: IndexPath(row: i, section: 0)), "Test Name", "It's not returning the employee name.")
            case 3:
            XCTAssertEqual(sut.getInformation(for: IndexPath(row: i, section: 0)), "123456789", "It's not returning the employee phone number.")
            case 4:
            XCTAssertEqual(sut.getInformation(for: IndexPath(row: i, section: 0)), "test@test.com", "It's not returning the employee email.")
            case 5:
            XCTAssertEqual(sut.getInformation(for: IndexPath(row: i, section: 0)), "Test", "It's not returning the employee team.")
            case 6:
            XCTAssertEqual(sut.getInformation(for: IndexPath(row: i, section: 0)), "FULL_TIME", "It's not returning the employee contract type.")
            case 7:
            XCTAssertEqual(sut.getInformation(for: IndexPath(row: i, section: 0)), "Test for class EmployeeDetailViewModel", "It's not returning the employee biography.")
            default:
                XCTAssertNil(sut.getInformation(for: IndexPath(row: i, section: 0)))
            }
        }
    }
    
    func testGetIcon() throws {
        for i in 0...7 {
            switch i {
            case 2:
                XCTAssertEqual(sut.getIcon(for: IndexPath(row: i, section: 0)), UIImage(named: "name"), "It's not returning the correct icon for name.")
            case 3:
            XCTAssertEqual(sut.getIcon(for: IndexPath(row: i, section: 0)), UIImage(named: "phone"), "It's not returning the correct icon for phone number.")
            case 4:
            XCTAssertEqual(sut.getIcon(for: IndexPath(row: i, section: 0)), UIImage(named: "email"), "It's not returning the correct icon for email.")
            case 5:
            XCTAssertEqual(sut.getIcon(for: IndexPath(row: i, section: 0)), UIImage(named: "team"), "It's not returning the correct icon for team.")
            case 6:
            XCTAssertEqual(sut.getIcon(for: IndexPath(row: i, section: 0)), UIImage(named: "employmentType"), "It's not returning the correct icon for employee contract type.")
            case 7:
            XCTAssertEqual(sut.getIcon(for: IndexPath(row: i, section: 0)), UIImage(named: "biography"), "It's not returning the correct icon for biography.")
            default:
                XCTAssertNil(sut.getIcon(for: IndexPath(row: i, section: 0)))
            }
        }
    }
}

class MockEmployee: Employee {
    
    init() {
        let contextTest = appDelegate?.persistentContainer.viewContext
        super.init(entity: Employee.entity(), insertInto: contextTest)
        uuid = "MOCK-USER-UUID"
        fullName = "Test Name"
        phoneNumber = "123456789"
        email = "test@test.com"
        employeeType = "FULL_TIME"
        biography = "Test for class EmployeeDetailViewModel"
        team = "Test"
        photoSmallNewURL = "https://some.url/MOCK-USER-UUID/small.jpeg"
        photoLargeNewURL = "https://some.url/MOCK-USER-UUID/large.jpeg"
    }
}

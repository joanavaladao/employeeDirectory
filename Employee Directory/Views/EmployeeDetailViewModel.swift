//
//  EmployeeDetailViewModel.swift
//  Employee Directory
//
//  Created by Joana Valadao on 2020-07-22.
//  Copyright © 2020 Joana Valadao. All rights reserved.
//

import UIKit

enum InformationType: Int {
    case photo = 0
    case name = 2
    case phone
    case email
    case team
    case type
    case biography
    
    func iconImage() -> UIImage? {
        switch self {
        case .photo: return nil
        case .name: return UIImage(named: "name")
        case .phone: return UIImage(named: "phone")
        case .email: return UIImage(named: "email")
        case .team: return UIImage(named: "team")
        case .type: return UIImage(named: "employmentType")
        case .biography: return UIImage(named: "biography")
        }
    }
    
    func information(employee: Employee) -> String? {
        switch self {
        case .photo: return nil
        case .name: return employee.fullName
        case .phone: return employee.phoneNumber
        case .email: return employee.email
        case .team: return employee.team
        case .type: return employee.employeeType
        case .biography: return employee.biography
        }
    }
    
    func font() -> UIFont {
        switch self {
        case .name: return UIFont.boldSystemFont(ofSize: 18.0)
        default: return UIFont.systemFont(ofSize: 16.0)
        }
    }
        
    func fontColor() -> UIColor {
        switch self {
        case .name: return .black
        default: return .darkGray
        }
    }
}

class EmployeeDetailViewModel {
    private var employee: Employee
    private var fileService: FileService
    private var downloadService: DownloadService?
    private var dataChanged: () -> Void
    
    init(_ employee: Employee, fileService: FileService = FileService(), downloadService: DownloadService? = nil, dataChanged: @escaping () -> Void) {
        self.employee = employee
        self.fileService = fileService
        self.downloadService = downloadService
        self.dataChanged = dataChanged
    }
    
    func numberOfRows() -> Int {
        return 8
    }
    
    func getImage() -> UIImage {
        let placeHolder: UIImage = UIImage(named: "person") ?? UIImage()
        if employee.shouldDownloadLargeImage() {
            downloadImage()
            if let filename = employee.photoSmallDisk,
                !filename.isEmpty {
                let imageURL = fileService.smallImagesFolder.appendingPathComponent(filename)
                return UIImage(contentsOfFile: imageURL.path) ?? placeHolder
            }
        } else {
            if let filename = employee.photoLargeDisk,
                !filename.isEmpty {
                let imageURL = fileService.largeImagesFolder.appendingPathComponent(filename)
                return UIImage(contentsOfFile: imageURL.path) ?? placeHolder
            }
        }
        
        return placeHolder
    }
    
    func getIcon(for index: IndexPath) -> UIImage? {
        guard let type = InformationType(rawValue: index.row) else {
            return nil
        }
        return type.iconImage()
    }
    
    func getInformation(for index: IndexPath) -> String? {
        guard let type = InformationType(rawValue: index.row) else {
            return nil
        }
        return type.information(employee: employee)
    }
    
    func getFont(for index: IndexPath) -> UIFont {
        guard let type = InformationType(rawValue: index.row) else {
            return UIFont.systemFont(ofSize: 15.0)
        }
        return type.font()
    }
    
    func getColor(for index: IndexPath) -> UIColor {
        guard let type = InformationType(rawValue: index.row) else {
            return .black
        }
        return type.fontColor()
    }
}

private extension EmployeeDetailViewModel {

    func downloadImage() {
        
        let downloadService = self.downloadService ?? DownloadService(delegate: self)
        
            let diskPath: String = employee.photoLargeDisk ?? ""
            if !diskPath.isEmpty {
                fileService.removeFile(at: diskPath)
                employee.photoLargeDisk = nil
            }
            employee.photoLargeURL = employee.photoLargeNewURL

            guard let newDiskPath = employee.photoLargeURL else {
                return
            }
            let filename = "\(employee.uuid)-\(URL(fileURLWithPath: newDiskPath).lastPathComponent)"
            employee.photoLargeDisk = filename
            appDelegate?.saveContext()
            
            downloadService.startDownload(of: .largeImage, from: newDiskPath, filename: filename)
        }
}

extension EmployeeDetailViewModel: DownloadDelegate {
    func savedTemporaryFile(at url: URL, downloadType: DownloadType) {
        dataChanged()
    }
    
    func errorDownloadingFile(_ error: Error, downloadType: DownloadType) {
        
    }
    
    func errorSavingFile(_ error: Error, downloadType: DownloadType) {
        
    }
    
    
}

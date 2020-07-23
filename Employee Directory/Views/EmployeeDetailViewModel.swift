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
}

class EmployeeDetailViewModel {
    var employee: Employee
    var fileService: FileService
    var downloadService: DownloadService?
    
    init(_ employee: Employee, fileService: FileService = FileService(), downloadService: DownloadService?) {
        self.employee = employee
        self.fileService = fileService
        self.downloadService = downloadService
    }
    
    func numberOfRows() -> Int {
        return 8
    }
    
    func getImage() -> UIImage {
        let placeHolder: UIImage = UIImage(named: "person") ?? UIImage()
        
        guard let filename = employee.photoLargeDisk else {
            
            return
        }
        
        if employee.photoLargeURL == employee.photoLargeNewURL || employee.photoLargeNewURL == nil {
        let imageURL = fileService.smallImagesFolder.appendingPathComponent(filename)
        if fileService.checkIfFileExists(path: imageURL.path),
            let image = UIImage(contentsOfFile: imageURL.path) {
            return image
        } else {
            
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
}

private extension EmployeeDetailViewModel {
    func downloadImage() {
        
        let downloadService = self.downloadService ?? DownloadService(delegate: self)
        
            let diskPath: String = employee.photoSmallDisk ?? ""
            if !diskPath.isEmpty {
                fileService.removeFile(at: diskPath)
                employee.photoSmallDisk = nil
            }
            employee.photoSmallURL = employee.photoSmallNewURL
            
            
            guard let newDiskPath = employee.photoSmallURL else {
                // TODO: erro?
                return
            }
            let filename = "\(employee.uuid)-\(URL(fileURLWithPath: newDiskPath).lastPathComponent)"
            employee.photoSmallDisk = filename
            appDelegate.saveContext()
            
            downloadService.startDownload(of: .smallImage, from: newDiskPath, filename: filename)
        }
    }
}

extension EmployeeDetailViewModel: DownloadDelegate {
    func savedTemporaryFile(at url: URL, downloadType: DownloadType) {
        <#code#>
    }
    
    func errorDownloadingFile(_ error: Error, downloadType: DownloadType) {
        <#code#>
    }
    
    func errorSavingFile(_ error: Error, downloadType: DownloadType) {
        <#code#>
    }
    
    
}

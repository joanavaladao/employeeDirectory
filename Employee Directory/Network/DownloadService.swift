//
//  Reader.swift
//  Employee Directory
//
//  Created by Joana Valadao on 2020-07-18.
//  Copyright © 2020 Joana Valadao. All rights reserved.
//

import Foundation

enum EmployeeListURL: String {
    case fullList = "https://raw.githubusercontent.com/joanavaladao/employeeDirectory/master/files/employees.json"
    case emptyList = "https://raw.githubusercontent.com/joanavaladao/employeeDirectory/master/files/emptylist.json"
    case timeout = "http://httpbin.org/delay/60000"
}

enum DownloadType {
    case list
    case largeImage
    case smallImage
}

protocol DownloadDelegate {
    func savedTemporaryFile(at url: URL, downloadType: DownloadType)
    func errorDownloadingFile(_ error: Error, downloadType: DownloadType)
    func errorSavingFile(_ error: Error, downloadType: DownloadType)
}

class DownloadService: NSObject {
    lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        return URLSession(configuration: configuration)
    }()
    
    var delegate: DownloadDelegate
    var fileService: FileService
    var downloadType: DownloadType = .list

    init(delegate: DownloadDelegate, fileService: FileService = FileService()) {
        self.delegate = delegate
        self.fileService = fileService
        self.fileService.createDirectories()
    }
    
    func startDownload (of type: DownloadType, from path: String, filename: String? = nil) {
        guard let requestURL: URL = URL(string: path) else {
            return
        }
        self.downloadType = type
        let task = session.downloadTask(with: requestURL) { url, response, error in
            guard error == nil else {
                return
            }
            
            guard let url = url else {
                return
            }
            
            switch self.downloadType {
            case .list:
                let filename: String = requestURL.lastPathComponent
                let status = self.fileService.saveTemporaryFile(from: url, filename: filename)
                switch status {
                case .success(let url):
                    self.fileService.persistEmployeeList(file: url)
                    self.delegate.savedTemporaryFile(at: url, downloadType: .list)
                case .failure(let error):
                    self.delegate.errorSavingFile(error, downloadType: self.downloadType)
                }
            default:
                guard let filename = filename else {
                    return
                }
                let destinyURL: URL = self.downloadType == .largeImage ? self.fileService.largeImagesFolder : self.fileService.smallImagesFolder
                let imageURL = destinyURL.appendingPathComponent(filename)
                
                let status = self.fileService.saveFile(from: url, to: imageURL.path)
                switch status {
                case .success(_):
                    self.delegate.savedTemporaryFile(at: url, downloadType: self.downloadType)
                case .failure(let error):
                    self.delegate.errorSavingFile(error, downloadType: self.downloadType)
                }
            }
        }
        task.resume()
    }
}

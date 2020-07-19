//
//  Reader.swift
//  Employee Directory
//
//  Created by Joana Valadao on 2020-07-18.
//  Copyright © 2020 Joana Valadao. All rights reserved.
//

import Foundation

enum EmployeeList: String {
    case fullList = "https://s3.amazonaws.com/sq-mobile-interview/employees.json"
    case wrongList = "https://s3.amazonaws.com/sq-mobile-interview/employees_malformed.json"
    case emptyList = "https://s3.amazonaws.com/sq-mobile-interview/employees_empty.json"
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
        let configuration = URLSessionConfiguration.background(withIdentifier: "com.valadao.joana.employeeDirectory")
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
    
    var delegate: DownloadDelegate
    var fileService: FileService
    var downloadType: DownloadType = .list

    init(delegate: DownloadDelegate, fileService: FileService = FileService()) {
        self.delegate = delegate
        self.fileService = fileService
        self.fileService.createDirectories()
    }
    
    func startDownload (of type: DownloadType, from path: String) {
        guard let requestURL: URL = URL(string: path) else {
            // TODO: throw an error
            return
        }
        self.downloadType = type
        let task = session.downloadTask(with: requestURL)
        task.resume()
    }
}

extension DownloadService: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let filename: String = downloadTask.originalRequest?.url?.lastPathComponent else {
            //TODO: treat error
            return
        }
        let save = fileService.saveTemporaryFile(from: location, filename: filename)
        switch save {
        case .success(let url):
            if downloadType == .list {
                fileService.saveList(file: url)
            }
            
            delegate.savedTemporaryFile(at: url, downloadType: downloadType)
        case .failure(let error):
            delegate.errorSavingFile(error, downloadType: downloadType)
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard let error = error else {
            return
        }
        delegate.errorDownloadingFile(error, downloadType: downloadType)
    }
}




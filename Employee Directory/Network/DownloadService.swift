//
//  Reader.swift
//  Employee Directory
//
//  Created by Joana Valadao on 2020-07-18.
//  Copyright © 2020 Joana Valadao. All rights reserved.
//

import Foundation

enum EmployeeListURL: String {
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
            // TODO: throw an error
            return
        }
        self.downloadType = type
        let task = session.downloadTask(with: requestURL) { url, response, error in
            guard error == nil else {
                // TODO: tratar erro
                return
            }
            
            guard let url = url else {
                //TODO: tratar erro
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

//extension DownloadService: URLSessionDownloadDelegate {
//    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
//        guard let filename: String = downloadTask.originalRequest?.url?.lastPathComponent else {
//            //TODO: treat error
//            return
//        }
//        let save = fileService.saveTemporaryFile(from: location, filename: filename)
//        switch save {
//        case .success(let url):
//            if downloadType == .list {
//                fileService.saveList(file: url)
//            }
//
//            delegate.savedTemporaryFile(at: url, downloadType: downloadType)
//        case .failure(let error):
//            delegate.errorSavingFile(error, downloadType: downloadType)
//        }
//    }
//
//    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
//        guard let error = error else {
//            return
//        }
//        delegate.errorDownloadingFile(error, downloadType: downloadType)
//    }
//}




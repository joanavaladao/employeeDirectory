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

enum DownloadErrors: Error {
    case wrongOriginURL
    case noDestinyURL(_ respose: URLResponse?)
    case unknown(code: Int, message: String?)
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
    
    func startDownload (from path: String, completionHandler handler: @escaping((Result<String, DownloadErrors>) -> Void)) {
        guard let requestURL: URL = URL(string: path) else {
            handler(.failure(.wrongOriginURL))
            return
        }

        let task = session.downloadTask(with: requestURL) { url, response, error in
            guard error == nil else {
                handler(.failure(.unknown(code: 0, message: error?.localizedDescription)))
                return
            }

            guard let url = url else {
                handler(.failure(.noDestinyURL(response)))
                return
            }
            
            let filename: String = requestURL.lastPathComponent
            let status = self.fileService.saveTemporaryFile(from: url, filename: filename)
            handler(.success(url.path))
        }
        task.resume()
    }
}

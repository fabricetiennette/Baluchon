//
//  URLSessionFake.swift
//  Baluchon
//
//  Created by Fabrice Etiennette on 15/02/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import Foundation

class URLSessionFake: URLSession {
    var data: Data?
    var response: URLResponse?
    var error: Error?
    
    init(data: Data?, response: URLResponse?, error: Error?) {
        self.data = data
        self.response = response
        self.error = error
    }
    
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSessionDataTaskFake()
        task.completionHandler = completionHandler
        task.data = data
        task.urlResponse = response
        task.reponseError = error
        return task
    }
    
    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSessionDataTaskFake()
        task.data = data
        task.urlResponse = response
        task.reponseError = error
        task.completionHandler = completionHandler
        return task
    }
}

class URLSessionDataTaskFake: URLSessionDataTask {
    var completionHandler: ((Data?, URLResponse?, Error?) -> Void)?
    
    var data: Data?
    var urlResponse: URLResponse?
    var reponseError: Error?
    
    override func resume() {
        completionHandler?(data, urlResponse, reponseError)
    }
    
    override func cancel() {}
}

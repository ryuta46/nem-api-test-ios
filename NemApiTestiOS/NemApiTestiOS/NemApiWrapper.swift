//
//  NemApiWrapper.swift
//  NemApiTestiOS
//
//  Created by Taizo Kusuda on 2017/11/11.
//  Copyright © 2017年 ryuta46. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class NemApiClient {
    private static let NODE_PORT = "7890"
    private let host: String
    private let urlBase: String

    init(_ host: String) {
        self.host = host
        self.urlBase = "http://\(host):\(NemApiClient.NODE_PORT)"
    }

    private func sendGetMessageToNis<T: Codable>(_ path: String, _ query: Dictionary<String, String>) -> Observable<T> {
        let urlString = createUrl(path, query)

        print("get request url = \(urlString)")
        let request = URLRequest(url: URL(string: urlString)!)


        return Observable.create { observer in
            let configuration = URLSessionConfiguration.default
            let session = URLSession(configuration: configuration)
            let task = session.dataTask(with: request) { data, response, error in
                if let data = data {
                    let decorder = JSONDecoder()
                    if let responseString = String(data:data, encoding: .utf8) {
                        print("response: \(responseString)")
                    }
                    if let result: T = try? decorder.decode(T.self, from: data) {
                        observer.onNext(result)
                    } else {
                        observer.onError(NSError(domain:"Failed to parse result.", code: -1, userInfo: nil))
                    }
                    observer.onCompleted()
                } else {
                    observer.onError(NSError(domain:"CommunicationError.", code: -1, userInfo: nil))
                }
            }
            task.resume()
            return Disposables.create { task.cancel() }
        }
    }
    private func sendPostMessageToNis<R: Codable, S: Codable>(_ path: String, _ body: R, _ query: Dictionary<String, String>) -> Observable<S> {
        let urlString = createUrl(path, query)

        let encoder = JSONEncoder()
        guard let requestBodyData = try? encoder.encode(body),
            let requestBody = String(data: requestBodyData, encoding: .utf8) else {
                fatalError("Failed to encode to json")
        }

        print("post request url = \(urlString) body = \(requestBody)")

        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = requestBodyData


        return Observable.create { observer in
            let configuration = URLSessionConfiguration.default
            let session = URLSession(configuration: configuration)
            let task = session.dataTask(with: request) { data, response, error in
                if let data = data {
                    let decorder = JSONDecoder()
                    if let responseString = String(data:data, encoding: .utf8) {
                        print("response: \(responseString)")
                    }
                    if let result: S = try? decorder.decode(S.self, from: data) {
                        observer.onNext(result)
                    } else {
                        observer.onError(NSError(domain:"Failed to parse result.", code: -1, userInfo: nil))
                    }
                    observer.onCompleted()
                } else {
                    observer.onError(NSError(domain:"CommunicationError.", code: -1, userInfo: nil))
                }
            }
            task.resume()
            return Disposables.create { task.cancel() }
        }
    }


    private func createUrl(_ path: String, _ query: Dictionary<String, String>) -> String {
        let url = urlBase + path
        if query.isEmpty {
            return url
        }

        var queries = "?"
        query.forEach { entry in
            queries += entry.key + "=" + entry.value + "&"
        }

        let endIndex = queries.index(queries.endIndex, offsetBy: -1)
        return url + queries[queries.startIndex..<endIndex]
    }


    func getAccountFromPublicKey(_ publicKey: String) -> Observable<AccountMetaDataPair> {
        return sendGetMessageToNis("/account/get/from-public-key", ["publicKey" : publicKey])
    }


    func transactionAnnounce(_ requestAnnounce: RequestAnnounce) -> Observable<NemAnnounceResult> {
        return sendPostMessageToNis("/transaction/announce", requestAnnounce, [:])
    }

}

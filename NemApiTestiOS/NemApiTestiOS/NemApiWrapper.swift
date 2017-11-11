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
    //private static let JSON = MediaType.parse("application/json; charset=utf-8")

    init(_ host: String) {
        self.host = host
        self.urlBase = "http://\(host):\(NemApiClient.NODE_PORT)"
    }

    func sendGetMessageToNis<T: Codable>(_ path: String, _ query: Dictionary<String, String>) -> Observable<T> {
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


    /*
    private inline fun <reified T : Any>sendGetMessageToNis(path: String, query: Map<String, String> = emptyMap()): Observable<T> {
        val url = createUrl(path, query)

        Log.v(tag, "get request url = $url")

        val request = Request.Builder().url(url).get().build()

        return Observable.create { subscriber ->
            val response = okClient.newCall(request).execute()
            val responseString = response.body()?.string()

            if (responseString == null) {
                subscriber.onError(Exception("Failed to get response body"))
            } else {
                Log.v(tag, "response = $responseString")
                val semanticResponse = Gson().fromJson(responseString, T::class.java)
                subscriber.onNext(semanticResponse)
            }
            subscriber.onComplete()
        }
    }
    private inline fun <R,reified S: Any>sendPostMessageToNis(path: String, body: R, query: Map<String, String> = emptyMap()): Observable<S> {
        val url = createUrl(path, query)

        val requestBodyString = Gson().toJson(body)
        val requestBody = RequestBody.create(JSON, requestBodyString)

        Log.v(tag, "post request url = $url, body = $requestBodyString")

        val request = Request.Builder().url(url).post(requestBody).build()

        return Observable.create { subscriber ->
            val response = okClient.newCall(request).execute()
            val responseString = response.body()?.string()

            if (responseString == null) {
                subscriber.onError(Exception("Failed to get response body"))
            } else {
                Log.v(tag, "response = $responseString")
                val semanticResponse = Gson().fromJson(responseString, S::class.java)
                subscriber.onNext(semanticResponse)
            }
            subscriber.onComplete()
        }
    }

    fun transactionAnnounce(requestAnnounce: RequestAnnounce): Observable<NemAnnounceResult> {
        return sendPostMessageToNis("/transaction/announce", requestAnnounce)
    }
 */

}

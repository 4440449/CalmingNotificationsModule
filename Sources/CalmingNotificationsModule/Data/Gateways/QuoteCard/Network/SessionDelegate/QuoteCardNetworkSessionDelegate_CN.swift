//
//  QuoteCardNetworkSessionDelegate_CN.swift
//  CalmingNotifications
//
//  Created by Maxim on 22.06.2022.
//  Copyright © 2022 Max. All rights reserved.
//

//import Foundation
//import MommysEye
//
//
//final class QuoteCardNetworkSessionDelegate_CN: NSObject,
//                                                URLSessionDataDelegate {
//
//    private var bytesReceived = Data()
//    private var expectedContentLength: Double = 0
//    var progress = Publisher(value: Double(0))
//
//
//    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse) async -> URLSession.ResponseDisposition {
//        expectedContentLength = Double(response.expectedContentLength)
//        print(expectedContentLength)
//        return .cancel
//    }
//
//    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
//        bytesReceived.append(data)
//        let percentageDownloaded = Double(bytesReceived.count) / expectedContentLength
//        progress.value = percentageDownloaded
//    }
//
//    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
//        progress.value = 1.0
//    }
//
//}

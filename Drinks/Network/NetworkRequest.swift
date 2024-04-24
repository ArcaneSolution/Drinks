//
//  NetworkRequest.swift
//  Drinks
//
//  Created by M Usman on 23/04/2024.
//

import Foundation
import Combine
//import SwiftyJSON

class NetworkRequest <Req:Encodable,Res:Codable> : NSObject{
    var method:HTTPMehtod = .get
    var url:String?
    var requestModel:Req!
    var bindings = Set<AnyCancellable>()
    
    
    init(method:HTTPMehtod,url:String,requestModel:Req) {
        self.method=method
        self.url=url
        self.requestModel=requestModel
    }
    init(method:HTTPMehtod,url:String) {
        self.method=method
        self.url=url
    }
    func fetchData() -> AnyPublisher<Res?, NetworkError> {
        return Future { promise in
            guard let url = URL(string: self.url!) else{
            promise(.failure(NetworkError.invalidURL))
                return
        }
            var request = URLRequest(url: url)
            request.httpMethod=self.method.rawValue
            if self.requestModel != nil , !(self.requestModel is String) {
                request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
                request.httpBody = self.requestModel.convertToJsonData
            }
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                        if let error = error {
                            promise(.failure(.requestFailed(error)))
                        }
                        guard let data = data else {
                            promise(.failure(.invalidResponse))
                            return
                        }
                        
                        do {
                            let decoder = JSONDecoder()
                            let decodedData = try decoder.decode(Res.self, from: data)
                            promise(.success(decodedData))
                        } catch {
                            promise(.failure(.decodingFailed(error)))
                        }
                    }.resume()
        }.eraseToAnyPublisher()
    }
}



//extension URLRequest {
//    public func debugLog() -> Self {
//        #if DEBUG
//        DispatchQueue.main.async {
//            debugPrint("=======================================")
//            debugPrint(self)
//            
//            if let requestBody = self.httpBody?.parseToString() {
//                debugPrint("Request Model :-")
//                print(requestBody)
//            }
//            debugPrint("=======================================")
//        }
//        #endif
//        return self
//    }
//}


//extension Data {
//    
//    func parseToString() -> String {
//           let swift = JSON(self)
//           //convert the JSON to a raw String
//           if let string = swift.rawString() {
//               return string
//           }
//        return ""
//    }
//    
//    func debugLog(url: String? = nil, method: String? = nil, responseModel: Any? = nil) {
//        print("\n")
//        debugPrint("<=======================================")
//        if  let url = url, let method = method, let model = responseModel {
//            print("\tURL = \(url) \n\tHTTP-Method = \(method) \n\tResponse Model = \(model)")
//        }
//        print("\n\tResponse :-")
//        print(self.parseToString())
//        debugPrint("=======================================>")
//    }
//}

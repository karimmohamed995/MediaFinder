//
//  APIManager.swift
//  MediaFinder
//
//  Created by Karim Mohamed on 16/01/2023.
//


import Alamofire

class APIManager {
    class func search(term: String, media:String, completion: @escaping(_ error:Error?, _ mediaArray: [Media]?) -> Void) {
        
        let params = ["term": term, "media": media]
        
        AF.request("https://itunes.apple.com/search",method: HTTPMethod.get,parameters: params, encoding: URLEncoding.default, headers: nil).response { response in
            guard response.error == nil  else{
                print(response.error!)
                completion(response.error,nil)
                return
            }
            guard let data = response.data else{
                print("No Data Get")
                return
            }
            do{
                let decoder = JSONDecoder()
                let mediArr = try decoder.decode(MediaResponse.self, from: data).results
                completion(nil,mediArr)
            }catch let error {
                completion(error,nil)
            }
        }
    }
}

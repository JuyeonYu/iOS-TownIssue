//
//  NetworkManager.swift
//  TownIssue
//
//  Created by 주연  유 on 2020/03/31.
//  Copyright © 2020 주연  유. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager {
    static let sharedInstance = NetworkManager()

    init() {}
    
    func requestCreatePost(paramters: Parameters, completion: @escaping (Any) -> Void) {
        let url = Network.baseURL + "/" + Network.apiKey + "/" + Network.boardKey + "/" + Network.commonKey
        
        AF.request(url, method: .post, parameters: paramters, encoding: JSONEncoding.default).responseJSON { (response) in
            debugPrint(response)
             switch response.result {
             case .success(let obj):
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
                    
                    let object = try? JSONDecoder().decode(PostCreateResponse.self, from: jsonData)
                    
                    guard let result = object else {
                        return
                    }
                    completion(result)
                    
                 } catch {
                   print(error.localizedDescription)
                }
            case .failure(let e):
                print(e.localizedDescription)
            }
        }
    }
    
    func requestUpdatePost(paramters: Parameters, completion: @escaping (Any) -> Void) {
        let url = Network.baseURL + "/" + Network.apiKey + "/" + Network.boardKey + "/" + Network.commonKey
        
        AF.request(url, method: .put, parameters: paramters, encoding: JSONEncoding.default).responseJSON { (response) in
            debugPrint(response)
             switch response.result {
             case .success(let obj):
                do {
                    let data = obj as? Int
                    guard let result = data else {
                        return
                    }
                    guard result == 1 else {
                        return
                    }
                    completion(result)  
                 }
            case .failure(let e):
                print(e.localizedDescription)
            }
        }
    }
    
    func requestReadAllPostList(completion: @escaping (Any) -> Void) {
        let url = Network.baseURL + "/" + Network.apiKey + "/" + Network.boardKey + "/" + Network.commonKey
        
        AF.request(url).responseJSON { response in
            debugPrint(response)
            switch response.result {
            case .success(let obj):
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
                    let result = try? JSONDecoder().decode([Post].self, from: jsonData)
                    
                    guard let postList = result else {
                        return
                    }
                    completion(postList)
                } catch {
                   print(error.localizedDescription)
                }
           case .failure(let e):
               print(e.localizedDescription)
           }
        }
    }
    
    func requestDeletePost(index: Int, completion: @escaping (Any) -> Void) {
        let url = Network.baseURL + "/" + Network.apiKey + "/" + Network.boardKey + "/" + Network.commonKey + "/" + String(index)
        AF.request(url, method: .delete).responseJSON { (response) in
            debugPrint(response)
             switch response.result {
             case .success(let obj):
                do {
                    let data = obj as? Int
                    guard let result = data else {
                        return
                    }
                    guard result == 1 else {
                        return
                    }
                    completion(result)
                 }
            case .failure(let e):
                print(e.localizedDescription)
            }
        }
    }
}

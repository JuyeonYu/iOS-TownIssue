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
        let url = Network.baseURL + "/" + Network.kAPI + "/" + Network.kBoard + "/" + Network.kCommon
        
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
        let url = Network.baseURL + "/" + Network.kAPI + "/" + Network.kBoard + "/" + Network.kCommon
        
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
        let url = Network.baseURL + "/" + Network.kAPI + "/" + Network.kBoard + "/" + Network.kCommon
        
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
    
    func requestReadPostWithAreaIndex(areaIndex: Int, completion: @escaping (Any) -> Void) {
        let url = Network.baseURL + "/" + Network.kAPI + "/" + Network.kBoard + "/" + Network.kCustom + "/" + Network.kAreaIndex + "/" + String(areaIndex)
        
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
        let url = Network.baseURL + "/" + Network.kAPI + "/" + Network.kBoard + "/" + Network.kCommon + "/" + String(index)
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
    
    func getPublicIPAddress(completion: @escaping (Any) -> Void) {
        
        let url = URL(string: "https://api.ipify.org")

        do {
            if let url = url {
                let ipAddress = try String(contentsOf: url)
                print("My public IP address is: " + ipAddress)
                completion(ipAddress)
            }
        } catch let error {
            print(error)
        }
    }
    
    func requestRegion1Depth(completion: @escaping (Any) -> Void) {
        let url = Network.baseURL + "/" + Network.kAPI + "/" + Network.kArea + "/" + Network.kCustom + "/" + Network.kDepth + "/" + Network.kDepth1
        AF.request(url).responseJSON { response in
            debugPrint(response)
             switch response.result {
             case .success(let obj):
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
                    
                    let object = try? JSONDecoder().decode([Region].self, from: jsonData)
                    
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
    
    func requestRegionsWithParentIndex(parentIndex: Int, completion: @escaping (Any) -> Void) {
        let url = Network.baseURL + "/" + Network.kAPI + "/" + Network.kArea + "/" + Network.kCustom + "/" + Network.kParentIndex + "/" + String(parentIndex)
        AF.request(url).responseJSON { response in
            debugPrint(response)
             switch response.result {
             case .success(let obj):
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
                    
                    let object = try? JSONDecoder().decode([Region].self, from: jsonData)
                    
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
}

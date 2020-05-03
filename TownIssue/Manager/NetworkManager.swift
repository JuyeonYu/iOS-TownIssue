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
    
//    MARK: Post
    func createPost(paramters: Parameters, completion: @escaping (APIResponse, Any?) -> Void) {
        let url = Network.Urls.baseURL + Network.Urls.createPost
        
        AF.request(url, method: .post, parameters: paramters, encoding: JSONEncoding.default).responseJSON { (response) in
            debugPrint(response)
             switch response.result {
             case .success(let obj):
                do {
                    let result: Int = obj as! Int
                    if result == 1 {
                        completion(APIResponse(isSucess: true, message: nil), obj)
                    } else {
                        completion(APIResponse(isSucess: false, message: nil), obj)
                    }
                      
                 }
            case .failure(let e):
                print(e.localizedDescription)
            }
        }
    }
    
    func readAreaPost(areaIndex:Int, completion: @escaping (APIResponse, Any) -> Void) {
        let url = Network.Urls.baseURL
            + Network.Urls.readPostWithAreaIndex
            + "/" + String(areaIndex)
            + "?" + Network.kSize + "=" + String(Network.kPagingSize)
            + "&" + Network.kSort + "=" + Network.kInsDate
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
                    completion(APIResponse(isSucess: true, message: nil), postList)
                } catch {
                   print(error.localizedDescription)
                }
           case .failure(let e):
               print(e.localizedDescription)
           }
        }
    }
    
    func readPost(postIndex:Int, completion: @escaping (APIResponse, Any) -> Void) {
        let url = Network.Urls.baseURL
            + Network.Urls.readPostWithBoardIndex
            + "/" + String(postIndex)
        AF.request(url).responseJSON { response in
            debugPrint(response)
            switch response.result {
            case .success(let obj):
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
                    let result = try? JSONDecoder().decode(Post.self, from: jsonData)
                    
                    guard let post = result else {
                        return
                    }
                    completion(APIResponse(isSucess: true, message: nil), post)
                } catch {
                   print(error.localizedDescription)
                }
           case .failure(let e):
               print(e.localizedDescription)
           }
        }
    }
    
    func updatePost(postIndex: Int, paramters: Parameters, completion: @escaping (APIResponse, Any) -> Void) {
        let url = Network.Urls.baseURL + Network.Urls.updatePostWithBoardIndex + "/" + String(postIndex)
        
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
                    completion(APIResponse(isSucess: true, message: nil), result)
                 }
            case .failure(let e):
                print(e.localizedDescription)
            }
        }
    }
    
    func deletePost(postIndex: Int, parameters: Parameters, completion: @escaping (APIResponse, Any) -> Void) {
        let url = Network.Urls.baseURL + Network.Urls.deletePostWithBoardIndex + "/" + String(postIndex)
        AF.request(url, method: .delete, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
            debugPrint(response)
             switch response.result {
             case .success(let obj):
                do {
                    let data = obj as? Int
                    guard let result = data else {
                        return
                    }
                    if result == 1 {
                        completion(APIResponse(isSucess: true, message: nil), result)
                    } else {
                        completion(APIResponse(isSucess: false, message: "wrong password"), result)
                    }
                 }
            case .failure(let e):
                print(e.localizedDescription)
            }
        }
    }
    
    func checkPostPassword(postIndex: Int, paramters: Parameters, completion: @escaping (APIResponse) -> Void) {
        let url = Network.Urls.baseURL + Network.Urls.checkPostPasswordWithBoardIndex + "/" + String(postIndex)
        
        AF.request(url, method: .post, parameters: paramters, encoding: JSONEncoding.default).responseJSON { (response) in
            debugPrint(response)
             switch response.result {
             case .success(let obj):
                print(obj)
                completion(APIResponse(isSucess: true, message: nil))
            case .failure(let e):
                print(e.localizedDescription)
                completion(APIResponse(isSucess: false, message: nil))
            }
        }
    }
    
    
    //    MARK: Region
    func readDepth1Regions(completion: @escaping (APIResponse, Any) -> Void) {
        let url = Network.Urls.baseURL + Network.Urls.readRegionsWithDepth + "/" + Network.kDepth1
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
                    completion(APIResponse(isSucess: true, message: nil), result)
                    
                 } catch {
                   print(error.localizedDescription)
                }
            case .failure(let e):
                print(e.localizedDescription)
            }
        }
    }
    
    func readSonRegions(parentIndex: Int, completion: @escaping (APIResponse, Any) -> Void) {
        let url = Network.Urls.baseURL + Network.Urls.readRegionsWithParentIndex + "/" + String(parentIndex)
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
                    completion(APIResponse(isSucess: true, message: nil), result)
                    
                 } catch {
                   print(error.localizedDescription)
                }
            case .failure(let e):
                print(e.localizedDescription)
            }
        }
    }
    
//    MARK: reply
    func createReply(paramters: Parameters, completion: @escaping (APIResponse) -> Void) {
        let url = Network.Urls.baseURL + Network.Urls.createReply
        
        AF.request(url, method: .post, parameters: paramters, encoding: JSONEncoding.default).responseJSON { (response) in
            debugPrint(response)
             switch response.result {
             case .success(let obj):
                do {
                    let result: Int = obj as! Int
                    if result == 1 {
                        completion(APIResponse(isSucess: true, message: nil))
                    } else {
                        completion(APIResponse(isSucess: false, message: nil))
                    }
                      
                 }
            case .failure(let e):
                print(e.localizedDescription)
            }
        }
    }
    
    func readReply(boardIndex:Int, completion: @escaping (APIResponse, Any) -> Void) {
        let url = Network.Urls.baseURL
            + Network.Urls.readReplyWithboardIndex
            + "/" + String(boardIndex)
            + "?" + Network.kSize + "=" + String(Network.kPagingSize)
            + "&" + Network.kSort + "=" + Network.kInsDate
        AF.request(url).responseJSON { response in
            debugPrint(response)
            switch response.result {
            case .success(let obj):
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
                    let result = try? JSONDecoder().decode([Reply].self, from: jsonData)
                    
                    guard let postList = result else {
                        return
                    }
                    completion(APIResponse(isSucess: true, message: nil), postList)
                } catch {
                   print(error.localizedDescription)
                }
           case .failure(let e):
               print(e.localizedDescription)
           }
        }
    }
    
    func updateReply(replyIndex: Int, paramters: Parameters, completion: @escaping (APIResponse) -> Void) {
        let url = Network.Urls.baseURL + Network.Urls.updateReplywithCommnetIndex + "/" + String(replyIndex)
        
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
                        completion(APIResponse(isSucess: false, message: nil))
                        return
                    }
                    completion(APIResponse(isSucess: true, message: nil))
                 }
            case .failure(let e):
                completion(APIResponse(isSucess: false, message: nil))
                print(e.localizedDescription)
            }
        }
    }
    
    func deleteReply(replyIndex: Int, parameters: Parameters, completion: @escaping (APIResponse) -> Void) {
        let url = Network.Urls.baseURL + Network.Urls.deleteReplyWithCommnetIndex + "/" + String(replyIndex)
        AF.request(url, method: .delete, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
            debugPrint(response)
             switch response.result {
             case .success(let obj):
                do {
                    let data = obj as? Int
                    guard let result = data else {
                        return
                    }
                    if result == 1 {
                        completion(APIResponse(isSucess: true, message: nil))
                    } else {
                        completion(APIResponse(isSucess: false, message: "wrong password"))
                    }
                 }
            case .failure(let e):
                print(e.localizedDescription)
            }
        }
    }
    
    func checkReplyPassword(replyIndex: Int, paramters: Parameters, completion: @escaping (APIResponse) -> Void) {
        let url = Network.Urls.baseURL + Network.Urls.checkReplyPasswordWithCommnetIndex + "/" + String(replyIndex)
        
        AF.request(url, method: .post, parameters: paramters, encoding: JSONEncoding.default).responseJSON { (response) in
            debugPrint(response)
             switch response.result {
             case .success(let obj):
                print(obj)
                completion(APIResponse(isSucess: true, message: nil))
            case .failure(let e):
                print(e.localizedDescription)
                completion(APIResponse(isSucess: false, message: nil))
            }
        }
    }
    
//    MARK: common
    func getPublicIPAddress(completion: @escaping (Any) -> Void) {
        let url = URL(string: "https://api.ipify.org")
        do {
            if let url = url {
                let ipAddress = try String(contentsOf: url)
                completion(ipAddress)
            }
        } catch let error {
            print(error)
        }
    }
}

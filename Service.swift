//
//  Service.swift
//  githubAPI
//
//  Created by Vinicius on 04/10/22.
//

import Foundation
enum ServiceError: Error {
    case invalidURL
    case decodeFail(Error?)
    case network(Error?)
    case noData
}

class GitService {
    let baseURL = "https://api.github.com/users/"
    
    func getUser(gitUser: String, callback: @escaping(Result<UserDetail, Error>) -> Void) {
    
        guard let url = URL(string: baseURL + gitUser) else {
            callback(.failure(ServiceError.invalidURL))
            return
        }
           let task = URLSession.shared.dataTask(with: url) { data, response, error in
               guard let data = data else {
                   callback(.failure(ServiceError.network(error)))
                   return
               }
                        do {
                            let gitUser = try? JSONDecoder().decode(UserDetail.self, from: data)
                            guard let gitUser = gitUser else {
                                callback(.failure(ServiceError.noData))
                                return
                            }
                            
                            callback(.success(gitUser))
                            //print(gitUser)
                        } catch {
                            callback(.failure(ServiceError.decodeFail(error)))
                        }
                    }
                    task.resume()
                }
    
    func getRepo(gitUser: String, callback: @escaping(Result<[Repo], Error>) -> Void) {
    
        guard let url = URL(string: baseURL + gitUser + "/repos") else {
            callback(.failure(ServiceError.invalidURL))
            return
        }
           let task = URLSession.shared.dataTask(with: url) { data, response, error in
               guard let data = data else {
                   callback(.failure(ServiceError.network(error)))
                   return
               }
                        do {
                            let repo = try? JSONDecoder().decode([Repo].self, from: data)
                            guard let repo = repo else {
                                callback(.failure(ServiceError.noData))
                                return
                            }
                            
                            callback(.success(repo))
                            //print(repo)
                        } catch {
                            callback(.failure(ServiceError.decodeFail(error)))
                        }
                    }
                    task.resume()
                }
    }


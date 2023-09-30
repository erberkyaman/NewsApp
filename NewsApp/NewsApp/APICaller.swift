//
//  APICaller.swift
//  NewsApp
//
//  Created by Erberk Yaman on 28.09.2023.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    
    struct Constants {
        static let topHeadlinesURL = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=955e0c905fcb4d8294b9f333cf1e747e")
        
        static let searchURLString = "https://newsapi.org/v2/everything?sortedBy=popularity&apiKey=955e0c905fcb4d8294b9f333cf1e747e&q="
    }
    
    private init() {}
    
    public func getTopStories (completion: @escaping (Result<[Article], Error>) -> Void) {
        guard let url = Constants.topHeadlinesURL else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    
                    print("Articles: \(result.articles.count)")
                    completion(.success(result.articles))
                }
                catch {
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
    
    public func newsBySearch (with query: String, completion: @escaping (Result<[Article], Error>) -> Void) {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        let urlString = Constants.searchURLString + query
        guard let url = URL(string: urlString) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    
                    completion(.success(result.articles))
                }
                catch {
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
    
    
}

// Models

struct APIResponse : Codable {
    let articles: [Article]
}

struct Article: Codable {
    let source : Source
    let title : String
    let description : String?
    let url : String
    let urlToImage : String?
    let publishedAt : String
}

struct Source: Codable {
    let name: String
}

//
//  Search.swift
//  StoreSearch
//
//  Created by Максим on 10.02.16.
//  Copyright © 2016 Maxim. All rights reserved.
//

import Foundation

class Search {
    var searchResults = [Result]()
    
    private var loading = false
    private var nothingFound = false
    
    private var dataTask: NSURLSessionDataTask? = nil
    
    func performSearchForText(text: String, category: Int, completion: SearchComplete) { //?
        if !text.isEmpty {
            
            dataTask?.cancel()
            self.loading = true
            self.nothingFound = false
            searchResults.removeAll()
            
            let url = urlWithSearchText(text, category: category)
            
            let session = NSURLSession.sharedSession()
            
            dataTask = session.dataTaskWithURL(url, completionHandler: {
                data, response, error in
                
                var success = false
                if let error = error where error.code == -999 {
                    return
                } else if let httpResponse = response as? NSHTTPURLResponse where httpResponse.statusCode == 200 {
                    if let data = data, dictionary = self.parseJSON(data) {
                        self.searchResults.appendContentsOf(self.parseDictinory(dictionary))
                        self.searchResults.sortInPlace(<)
                        self.loading = false
                        success = true
                    }
                } else {
                    self.nothingFound = true
                    self.loading = false
                }
                dispatch_async(dispatch_get_main_queue()){
                    completion(success)
                }
            })
            dataTask?.resume()
        }
    }
    
    func performStoreRequestWithURL(url: NSURL) -> String? {
        do {
            return try String(contentsOfURL: url, encoding: NSUTF8StringEncoding)
        } catch {
            print("Downland error \(error)")
            return nil
        }
    }
    
    private func urlWithSearchText(searchText: String, category: Int) -> NSURL {
        let entityName: String
        switch category {
        case 1: entityName = "musicTrack"
        case 2: entityName = "software"
        case 3: entityName = "ebook"
        default: entityName = ""
        }
        
        let escapedSearchText = searchText.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        let urlInString = String(format: "http://itunes.apple.com/search?term=%@&limit=50&entity=%@", escapedSearchText, entityName)
        let url = NSURL(string: urlInString)
        return url!
    }
    
    private func parseJSON(data: NSData) -> [String: AnyObject]? {
        do {
            return try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String: AnyObject]
        } catch {
            print("JSON error: \(error)")
            return nil
        }
    }
    
    private func parseDictinory(dictionary: [String: AnyObject]) -> [Result] {
        guard let array = dictionary["results"] as? [AnyObject] else {
            print("Exepted 'result' array")
            return []
        }
        
        var searchResult = [Result]()
        for resultDict in array {
            if let resultDict = resultDict as? [String: AnyObject] {
                if let wrapperType = resultDict["wrapperType"] as? String {
                    switch wrapperType {
                    case "track":
                        searchResult.append(TrackResult(dictionary: resultDict))
                    case "audiobook":
                        searchResult.append(AudioBookResult(dictionary: resultDict))
                    case "software":
                        searchResult.append(AppResult(dictionary: resultDict))
                    default :
                        break
                    }
                } else if let kind = resultDict["kind"] as? String where kind == "ebook"{
                    searchResult.append(EBookResult(dictionary: resultDict))
                }
            }
        }
        if searchResult.isEmpty {
            self.nothingFound = true
        }
        return searchResult
    }
    
    func isLoading() -> Bool {
        return loading
    }
    func isNoFound() -> Bool{
        return nothingFound
    }
    func getCount() -> Int {
        if self.isLoading() || self.isNoFound() {
            return 1
        } else {
            return searchResults.count
        }
    }
}

typealias SearchComplete = (Bool) -> Void

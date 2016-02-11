//
//  Search.swift
//  StoreSearch
//
//  Created by Максим on 10.02.16.
//  Copyright © 2016 Maxim. All rights reserved.
//

import UIKit
import Foundation

class Search {
    
    enum State {
        case NotSearchYet
        case Loading
        case NoFound
        case Results([Result])
    }
    
    private(set) var state: State = .NotSearchYet
    
    private var dataTask: NSURLSessionDataTask? = nil
    
    enum Category: Int {
        case All = 0
        case Music = 1
        case Software = 2
        case EBook = 3
        
        var entityName: String {
            switch self {
            case .All: return ""
            case .Music: return "musicTrack"
            case .Software: return "software"
            case .EBook: return "ebook"
            }
        }
    }
    
    func performSearchForText(text: String, category: Category, completion: SearchComplete) { //?
        if !text.isEmpty {
            
            dataTask?.cancel()
            state = .Loading
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            
            let url = urlWithSearchText(text, category: category)
            
            let session = NSURLSession.sharedSession()
            var searchResults = [Result]()
            dataTask = session.dataTaskWithURL(url, completionHandler: {
                data, response, error in
                
                self.state = .NotSearchYet
                var success = false
                if let error = error where error.code == -999 {
                    return // serach was canceled
                } else if let httpResponse = response as? NSHTTPURLResponse where httpResponse.statusCode == 200, let data = data, dictionary = self.parseJSON(data) {
                 
                    searchResults.appendContentsOf(self.parseDictinory(dictionary))
                    if searchResults.isEmpty {
                        self.state = .NoFound
                    } else {
                        searchResults.sortInPlace(<)
                        self.state = .Results(searchResults)
                    }
                    success = true
                }
                dispatch_async(dispatch_get_main_queue()){
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
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
    
    private func urlWithSearchText(searchText: String, category: Category) -> NSURL {
        let entityName: String = category.entityName

        let locale = NSLocale.autoupdatingCurrentLocale()
        let language = locale.localeIdentifier
        let countryCode = locale.objectForKey(NSLocaleCountryCode) as! String
        
        let escapedSearchText = searchText.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        let urlInString = String(format: "http://itunes.apple.com/search?term=%@&limit=50&entity=%@&land=%@&country=%@", escapedSearchText, entityName, language, countryCode)
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
        return searchResult
    }
    
    func getCount() -> Int {
        switch state{
        case .NotSearchYet: return 0
        case .Loading, .NoFound: return 1
        case .Results(let searchResults): return searchResults.count
        }
    }
}

typealias SearchComplete = (Bool) -> Void
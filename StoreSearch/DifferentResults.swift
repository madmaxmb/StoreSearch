//
//  DifferentResults.swift
//  StoreSearch
//
//  Created by Максим on 10.02.16.
//  Copyright © 2016 Maxim. All rights reserved.
//

import UIKit

protocol Result {
    var artworkURL60: String {get}
    var artworkURL100: String {get}
    var kind:String {get}
    var genre: String {get}
    var price: Double {get}
    var currency: String {get}
    var storeURL: String {get}
    
    func getName() -> String
    func getArtistName() -> String
    func getArtworkImageURL60() -> NSURL?
    func getArtworkImageURL100() -> NSURL?
    func isNoFound() -> Bool
    func getKindForDisplay() -> String
    func getGenre() -> String
    func getCurrency() -> String
    func getPrice() -> Double
    func getStore() -> NSURL?
    func isLoad() -> Bool
}

extension Result {
    func getName() -> String {
        return ""
    }
    func getArtistName() -> String {
        return ""
    }
    
    func getKindForDisplay() -> String {
        switch self.kind {
        case "album": return "Album"
        case "audiobook": return "Audio Book"
        case "book": return "Book"
        case "ebook": return "E-Book"
        case "feature-movie": return "Movie"
        case "music-video": return "Music Video"
        case "podcast": return "Podcast"
        case "software": return "App"
        case "song": return "Song"
        case "tv-episode": return "TV Episode"
        default: return self.kind
        }
    }
    func getStore() -> NSURL? {
        return NSURL(string: self.storeURL)
    }
    func getArtworkImageURL60() -> NSURL? {
        return NSURL(string: self.artworkURL60)
    }
    func getArtworkImageURL100() -> NSURL? {
        return NSURL(string: self.artworkURL100)
    }
    func getGenre() -> String {
        return genre
    }
    func getPrice() -> Double{
        return price
    }
    func getCurrency() -> String {
        return currency
    }
    
    func isLoad() -> Bool {
        return false
    }
    func isNoFound() -> Bool {
        return false
    }
}

class NoFoundResult: Result {
    internal var kind = ""
    internal var artworkURL60 = ""
    internal var artworkURL100 = ""
    internal var genre = ""
    internal var price = 0.0
    var storeURL = ""
    
    var currency = ""
    
    func getName() -> String {
        return "(Nothing found)"
    }
    func isNoFound() -> Bool {
        return true
    }
    func getStore() -> NSURL? {
        return nil
    }
    func getArtworkImageURL60() -> NSURL? {
        return nil
    }
    func getArtworkImageURL100() -> NSURL? {
        return nil
    }
}

class TrackResult: Result {
    private var name: String
    private var artistName: String
    internal var artworkURL60: String
    internal var artworkURL100: String
    internal var storeURL: String
    internal var kind: String
    internal var currency: String
    internal var price: Double
    internal var genre: String
    
    init(dictionary: [String: AnyObject]){
        self.name = dictionary["trackName"] as! String
        self.artistName = dictionary["artistName"] as! String
        self.artworkURL60 = dictionary["artworkUrl60"] as! String
        self.artworkURL100 = dictionary["artworkUrl100"] as! String
        self.storeURL = dictionary["trackViewUrl"] as! String
        self.kind = dictionary["kind"] as! String
        self.currency = dictionary["currency"] as! String
        
        if let price = dictionary["trackPrice"] as? Double{
            self.price = price
        } else {
            self.price = 0.0
        }
        
        if let genre = dictionary["primaryGenreName"] as? String {
            self.genre = genre
        } else {
            self.genre = ""
        }
    }
    func getName() -> String{
        return name
    }
    func getArtistName() -> String {
        return artistName
    }
}

class AudioBookResult: Result {
    private var name: String
    private var artistName: String
    internal var artworkURL60: String
    internal var artworkURL100: String
    internal var storeURL: String
    internal var kind: String
    internal var currency: String
    internal var price: Double
    internal var genre: String
    
    init(dictionary: [String: AnyObject]){
        self.name = dictionary["collectionName"] as! String
        self.artistName = dictionary["artistName"] as! String
        self.artworkURL60 = dictionary["artworkUrl60"] as! String
        self.artworkURL100 = dictionary["artworkUrl100"] as! String
        self.storeURL = dictionary["collectionViewUrl"] as! String
        self.kind = "audiobook"
        self.currency = dictionary["currency"] as! String
        
        if let price = dictionary["collectionPrice"] as? Double{
            self.price = price
        } else {
            self.price = 0.0
        }
        
        if let genre = dictionary["primaryGenreName"] as? String {
            self.genre = genre
        } else {
            self.genre = ""
        }
    }
    func getName() -> String{
        return name
    }
    func getArtistName() -> String {
        return artistName
    }
}

class AppResult: Result {
    private var name: String
    private var artistName: String
    internal var artworkURL60: String
    internal var artworkURL100: String
    internal var storeURL: String
    internal var kind: String
    internal var currency: String
    internal var price: Double
    internal var genre: String
    
    init(dictionary: [String: AnyObject]){
        self.name = dictionary["trackName"] as! String
        self.artistName = dictionary["artistName"] as! String
        self.artworkURL60 = dictionary["artworkUrl60"] as! String
        self.artworkURL100 = dictionary["artworkUrl100"] as! String
        self.storeURL = dictionary["trackViewUrl"] as! String
        self.kind = dictionary["kind"] as! String
        self.currency = dictionary["currency"] as! String
        
        if let price = dictionary["price"] as? Double{
            self.price = price
        } else {
            self.price = 0.0
        }
        
        if let genre = dictionary["primaryGenreName"] as? String {
            self.genre = genre
        } else {
            self.genre = ""
        }
    }
    func getName() -> String{
        return name
    }
    func getArtistName() -> String {
        return artistName
    }
}

class EBookResult: Result {
    private var name: String
    private var artistName: String
    internal var artworkURL60: String
    internal var artworkURL100: String
    internal var storeURL: String
    internal var kind: String
    internal var currency: String
    internal var price: Double
    internal var genre: String
    
    init(dictionary: [String: AnyObject]){
        self.name = dictionary["trackName"] as! String
        self.artistName = dictionary["artistName"] as! String
        self.artworkURL60 = dictionary["artworkUrl60"] as! String
        self.artworkURL100 = dictionary["artworkUrl100"] as! String
        self.storeURL = dictionary["trackViewUrl"] as! String
        self.kind = dictionary["kind"] as! String
        self.currency = dictionary["currency"] as! String
        
        if let price = dictionary["price"] as? Double{
            self.price = price
        } else {
            self.price = 0.0
        }
        
        if let genre = dictionary["geners"] as? String {
            self.genre = genre
        } else {
            self.genre = ""
        }
    }
    func getName() -> String{
        return name
    }
    func getArtistName() -> String {
        return artistName
    }
}

class LoadingResult: Result {
    var name: String
    var kind = ""
    var artworkURL60 = ""
    var artworkURL100 = ""
    var genre = ""
    var price = 0.0
    var currency = ""
    var storeURL = ""
    init() {
        self.name = "Loading"
    }
    func getArtistName() -> String {
        return name
    }
    func isLoad() -> Bool {
        return true
    }
    func getStore() -> NSURL? {
        return nil
    }
    func getArtworkImageURL60() -> NSURL? {
        return nil
    }
    func getArtworkImageURL100() -> NSURL? {
        return nil
    }
}

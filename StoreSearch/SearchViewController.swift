//
//  ViewController.swift
//  StoreSearch
//
//  Created by Максим on 31.01.16.
//  Copyright © 2016 Maxim. All rights reserved.
//

import UIKit

protocol Result {
    var kind:String {get}
    func getName() -> String
    func getArtistName() -> String
    func isNoFound() -> Bool
    func getKindForDisplay() -> String
}

extension Result {
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
}

class NoFoundResult: Result {
    internal var kind = ""
    func getName() -> String {
        return "(Nothing found)"
    }
    func isNoFound() -> Bool {
        return true
    }
}

class TrackResult: Result {
    private var name: String
    private var artistName: String
    private var artworkURL60: String
    private var artworkURL100: String
    private var storeURL: String
    internal var kind: String
    private var currency: String
    private var price: Double
    private var genre: String
    
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
    func isNoFound() -> Bool {
        return false
    }
}

class AudioBookResult: Result {
    private var name: String
    private var artistName: String
    private var artworkURL60: String
    private var artworkURL100: String
    private var storeURL: String
    internal var kind: String
    private var currency: String
    private var price: Double
    private var genre: String
    
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
    func isNoFound() -> Bool {
        return false
    }
}

class AppResult: Result {
    private var name: String
    private var artistName: String
    private var artworkURL60: String
    private var artworkURL100: String
    private var storeURL: String
    internal var kind: String
    private var currency: String
    private var price: Double
    private var genre: String
    
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
    func isNoFound() -> Bool {
        return false
    }
}

class EBookResult: Result {
    private var name: String
    private var artistName: String
    private var artworkURL60: String
    private var artworkURL100: String
    private var storeURL: String
    internal var kind: String
    private var currency: String
    private var price: Double
    private var genre: String
    
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
    func isNoFound() -> Bool {
        return false
    }
}

class TableViewCellIdentifiers {
    static let searchResultCell = "SearchResultCell"
    static let nothingFoundCell = "NothingFoundCell"
}

class SearchViewController: UIViewController {
    
    var searchResults = [Result]()
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
//         Do any additional setup after loading the view, typically from a nib.
        var cellNib = UINib(nibName: TableViewCellIdentifiers.searchResultCell, bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.searchResultCell)
        
        cellNib = UINib(nibName: TableViewCellIdentifiers.nothingFoundCell, bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.nothingFoundCell)
        
        tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
        tableView.rowHeight = 80
    
        searchBar.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func performStoreRequestWithURL(url: NSURL) -> String? {
        do {
            return try String(contentsOfURL: url, encoding: NSUTF8StringEncoding)
        } catch {
            print("Downland error \(error)")
            return nil
        }
    }
    
    func urlWithSearchText(searchText: String) -> NSURL {
        let escapedSearchText = searchText.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        let urlInString = String(format: "http://itunes.apple.com/search?term=%@", escapedSearchText)
        let url = NSURL(string: urlInString)
        return url!
    }
    
    func parseJSON(jsonString: String) -> [String: AnyObject]? {
        guard let data = jsonString.dataUsingEncoding(NSUTF8StringEncoding) else {
                return nil
        }
        do {
            return try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String: AnyObject]
        } catch {
            print("JSON Error: \(error)")
            return nil
        }
    }
    
    func showNetworkError() {
        if #available(iOS 8.0, *) {
            let alert = UIAlertController(title: "Whoops...", message: "There was an error reading from the iTunes Store. Please try again.", preferredStyle: .Alert)
            let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
            alert.addAction(action)
            
            presentViewController(alert, animated: true, completion: nil)
        } else {
            // Fallback on earlier versions
            let alert = UIAlertView(title: "Whoops...", message: "There was an error reading from the iTunes Stire. Please try again.", delegate: self, cancelButtonTitle: "Ok")
            alert.alertViewStyle = .Default //UIAlertViewStyle.PlainTextInput
            alert.show()
        }
        
    }
    
    func parseDictinory(dictionary: [String: AnyObject]) -> [Result] {
        guard let array = dictionary["results"] as? [AnyObject] else {
            print("Exepted 'result' array")
            return []
        }
        var searchResult = [Result]()
        for resultDict in array {
            if let resultDict = resultDict as? [String: AnyObject] {
                if let wrapperType = resultDict["wrapperType"] as? String, let _ = resultDict["kind"] as? String {
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
                }
                else if let kind = resultDict["king"] as? String where kind == "ebook" {
                    searchResult.append(EBookResult(dictionary: resultDict))
                }
            }
        }
        return searchResult
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if !searchBar.text!.isEmpty {
            searchBar.resignFirstResponder()
            searchResults.removeAll()
            let url = urlWithSearchText(searchBar.text!)
            if let queryResultInJsonString = performStoreRequestWithURL(url) {
                if let dictionary = parseJSON(queryResultInJsonString) {
                    searchResults.appendContentsOf(parseDictinory(dictionary))
                    searchResults.sortInPlace {$0.getName().localizedStandardCompare($1.getName()) == .OrderedAscending}
                    tableView.reloadData()
                }
                return
            }
            showNetworkError()
        }
    }
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if searchResults[indexPath.item].isNoFound(){
            return tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifiers.nothingFoundCell, forIndexPath: indexPath)
        }
        let cell = tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifiers.searchResultCell, forIndexPath: indexPath) as! SearchResultCell
        
        cell.nameLabel.text = searchResults[indexPath.row].getName()
        if searchResults[indexPath.row].getArtistName().isEmpty {
            cell.artistNameLabel.text = "Unknown"
        } else {
            cell.artistNameLabel.text = String(format: "%@ (%@)", searchResults[indexPath.row].getArtistName(), searchResults[indexPath.row].getKindForDisplay())
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if searchResults.isEmpty {
            return nil
        } else {
            if searchResults[indexPath.item].isNoFound() {
                return nil
            }
            return indexPath
        }
    }
}
extension SearchViewController: UITableViewDelegate {
}

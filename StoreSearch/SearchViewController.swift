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
    func isLoad() -> Bool {
        return false
    }
    func isNoFound() -> Bool {
        return false
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
}

class LoadingResult: Result {
    var name: String
    var kind: String
    init() {
        self.name = "Loading"
        self.kind = "Loading"
    }
    func getArtistName() -> String {
        return name
    }
    func isLoad() -> Bool {
        return true
    }
}

class TableViewCellIdentifiers {
    static let searchResultCell = "SearchResultCell"
    static let nothingFoundCell = "NothingFoundCell"
    static let loadingCell = "LoadingCell"
}

class SearchViewController: UIViewController {
    
    var searchResults = [Result]()
    var dataTask: NSURLSessionDataTask?
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
//         Do any additional setup after loading the view, typically from a nib.
        var cellNib = UINib(nibName: TableViewCellIdentifiers.searchResultCell, bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.searchResultCell)
        
        cellNib = UINib(nibName: TableViewCellIdentifiers.nothingFoundCell, bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.nothingFoundCell)
        
        cellNib = UINib(nibName: TableViewCellIdentifiers.loadingCell, bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.loadingCell)
        
        tableView.contentInset = UIEdgeInsets(top: 108, left: 0, bottom: 0, right: 0)
        tableView.rowHeight = 80
    
        searchBar.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func segmentChanged(sender: UISegmentedControl) {
        performSearch()
    }
    
    func performStoreRequestWithURL(url: NSURL) -> String? {
        do {
            return try String(contentsOfURL: url, encoding: NSUTF8StringEncoding)
        } catch {
            print("Downland error \(error)")
            return nil
        }
    }
    
    func urlWithSearchText(searchText: String, category: Int) -> NSURL {
        let entityName: String
        switch category {
            case 1: entityName = "musicTrack"
            case 2: entityName = "software"
            case 3: entityName = "ebook"
            default: entityName = ""
        }
        
        let escapedSearchText = searchText.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        let urlInString = String(format: "http://itunes.apple.com/search?term=%@&limit=20&entity=%@", escapedSearchText, entityName)
        let url = NSURL(string: urlInString)
        return url!
    }
    
    func parseJSON(data: NSData) -> [String: AnyObject]? {
        do {
            return try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String: AnyObject]
        } catch {
            print("JSON error: \(error)")
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
            searchResult.append(NoFoundResult())
        }
        return searchResult
    }
}

extension SearchViewController: UISearchBarDelegate {
    func performSearch() {
        if !searchBar.text!.isEmpty {
            searchBar.resignFirstResponder()
            searchResults.removeAll()
            
            dataTask?.cancel()
            
            searchResults.append(LoadingResult())
            tableView.reloadData()

            let url = urlWithSearchText(searchBar.text!, category: segmentControl.selectedSegmentIndex)
            
            let session = NSURLSession.sharedSession()
            
            dataTask = session.dataTaskWithURL(url, completionHandler: {
                data, response, error in
                if let error = error where error.code == -999 {
                    return
                } else if let httpResponse = response as? NSHTTPURLResponse where httpResponse.statusCode == 200 {
                    if let data = data, dictionary = self.parseJSON(data) {
                        self.searchResults.removeAll()
                        self.searchResults.appendContentsOf(self.parseDictinory(dictionary))
                        self.searchResults.sortInPlace(<)
                        dispatch_async(dispatch_get_main_queue()) {
                            self.tableView.reloadData()
                        }
                    }
                } else {
                    self.searchResults.removeAll()
                    self.searchResults.append(NoFoundResult())
                    dispatch_async(dispatch_get_main_queue()){
                        self.tableView.reloadData()
                        self.showNetworkError()
                    }
                }
            })
            dataTask?.resume()
           
        }
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        performSearch()
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
        
        if searchResults[indexPath.item].isLoad(){
            let cell =  tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifiers.loadingCell, forIndexPath: indexPath)
            let spinner = cell.viewWithTag(100) as! UIActivityIndicatorView
            spinner.startAnimating()
            return cell
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
            if searchResults[indexPath.item].isNoFound() || searchResults[indexPath.item].isLoad() {
                return nil
            }
            return indexPath
        }
    }
}
extension SearchViewController: UITableViewDelegate {
}

func < (left: Result, right: Result) -> Bool {
    return left.getName().localizedStandardCompare(right.getName()) == .OrderedAscending
}

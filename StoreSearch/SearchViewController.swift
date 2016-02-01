//
//  ViewController.swift
//  StoreSearch
//
//  Created by Максим on 31.01.16.
//  Copyright © 2016 Maxim. All rights reserved.
//

import UIKit

protocol Result {
    func getName() -> String
    func getArtistName() -> String
    func isNoFound() -> Bool
}

class NoFoundResult: Result {
    func getName() -> String {
        return "(Nothing found)"
    }
    func getArtistName() -> String {
        return ""
    }
    func isNoFound() -> Bool {
        return true
    }
}

class SearchResult: Result {
    private var name: String
    private var artistName: String
    init(name: String, artistName: String){
        self.name = name
        self.artistName = artistName
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
        guard let data = jsonString.dataUsingEncoding(NSUTF8StringEncoding)
            else {
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
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if !searchBar.text!.isEmpty {
            searchBar.resignFirstResponder()
            searchResults.removeAll()
            let url = urlWithSearchText(searchBar.text!)
            if let queryResultInJsonString = performStoreRequestWithURL(url) {
                if let dictionary = parseJSON(queryResultInJsonString) {
                    print("Dictionary: \(dictionary)")
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
        cell.artistNameLabel.text = searchResults[indexPath.row].getArtistName()
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

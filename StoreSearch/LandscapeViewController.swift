//
//  LandscapeViewController.swift
//  StoreSearch
//
//  Created by Максим on 09.02.16.
//  Copyright © 2016 Maxim. All rights reserved.
//

import UIKit

class LandscapeViewController: UIViewController {

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var search = Search()
    private var firstTime = true
    private var downloadTasks = [NSURLSessionDownloadTask]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.removeConstraints(view.constraints)
        view.translatesAutoresizingMaskIntoConstraints = true
        
        pageControl.removeConstraints(pageControl.constraints)
        pageControl.translatesAutoresizingMaskIntoConstraints = true
        
        scrollView.removeConstraints(scrollView.constraints)
        scrollView.translatesAutoresizingMaskIntoConstraints = true
        
        scrollView.backgroundColor = UIColor(patternImage: UIImage(named: "LandscapeBackground")!)
        scrollView.contentSize = CGSize(width: 1000, height: 1000)
        
        scrollView.delegate = self
        
        pageControl.numberOfPages = 0
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pageChanged(sender: AnyObject) {
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut, animations: {
            self.scrollView.contentOffset = CGPoint(
                x: self.scrollView.bounds.size.width * CGFloat(sender.currentPage), y: 0)
            }, completion: nil)
       
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        scrollView.frame = view.bounds
        
        pageControl.frame = CGRect (
            x: 0,
            y: view.frame.size.height - pageControl.frame.size.height,
            width: view.frame.size.width,
            height: pageControl.frame.size.height)
        
        if firstTime {
            firstTime = false
            switch search.state {
            case .NoFound:
                showNoFound()
            case .Loading:
                showSpinner()
            case .Results(let list):
                tileButtons(list)
            case .NotSearchYet:
                break
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func searchResultReceived() {
        hideSpinner()
        
        switch search.state {
        case .NotSearchYet, .Loading:
            break;
        case .NoFound:
            showNoFound()
        case .Results(let list):
            tileButtons(list)
        }
    }
    
    private func tileButtons(list: [Result]){
        var columnsPerPage = 5
        var rowsPerPage = 3
        var itemWidth: CGFloat = 96
        var itemHeight: CGFloat = 88
        var marginX: CGFloat = 0
        var marginY: CGFloat = 20
        
        let scrollViewWidth = scrollView.bounds.size.width
        
        switch scrollViewWidth {
        case 568:
            columnsPerPage = 6
            itemWidth = 94
            marginX = 2
            
        case 667:
            columnsPerPage = 7
            itemWidth = 95
            itemHeight = 98
            marginX = 1
            marginY = 29
            
        case 736:
            columnsPerPage = 8
            rowsPerPage = 4
            itemWidth = 92
        default:
            break
        }
        let buttonWidth: CGFloat = 82
        let buttonHeigght: CGFloat = 82
        let paddingHorz = (itemWidth - buttonWidth)/2
        let paddingVert = (itemHeight - buttonHeigght)/2
        
        var row = 0
        var column = 0
        var x = marginX
        
            for (index, searchResult) in list.enumerate() {
            
                let button = UIButton(type: .Custom)
                button.setBackgroundImage(UIImage(named: "LandscapeButton"), forState: .Normal)
                downloadImageForSearchResult(searchResult, andPlaceOnButton: button)
            
                button.frame = CGRect(
                    x: x + CGFloat(column) * itemWidth + paddingHorz,
                    y: marginY + CGFloat(row) * itemHeight + paddingVert,
                    width: buttonWidth, height: buttonHeigght)
                button.tag = 2000 + index
                button.addTarget(self, action: Selector("buttonClicked:"), forControlEvents: .TouchUpInside)
                scrollView.addSubview(button)
        
                ++column
                
                if column == columnsPerPage {
                    column = 0
                    row++
                    if row == rowsPerPage {
                        row = 0
                        x = x + CGFloat(columnsPerPage) * CGFloat(itemWidth) + marginX * 2
                    }
                }
            }

        let buttonsPerPage = columnsPerPage * rowsPerPage
        let numPages = 1 + (search.getCount() - 1) / buttonsPerPage
        
        pageControl.numberOfPages = numPages
        pageControl.currentPage = 0
        
        scrollView.contentSize = CGSize(
            width: CGFloat(numPages)*scrollViewWidth,
            height: scrollView.bounds.size.height)
    }
    
    func buttonClicked(sender: UIButton) {
        performSegueWithIdentifier("ShowDetail", sender: sender)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetail" {
            if case .Results(let list) = search.state {
                let detailViewController = segue.destinationViewController as! DetailViewController
                
                let searchResult = list[sender!.tag - 2000]
                detailViewController.searchResult = searchResult
            }
        }
    }
    
    private func showSpinner() {
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        spinner.center = scrollView.center
        spinner.tag = 1000
        scrollView.addSubview(spinner)
        spinner.startAnimating()
        pageControl.numberOfPages = 0
    }
    private func hideSpinner(){
        view.viewWithTag(1000)?.removeFromSuperview()
    }
    
    private func showNoFound() {
        let noFound = UILabel(frame: CGRect.zero)
        noFound.text = "Nothing Found"
        noFound.sizeToFit()
        noFound.textColor = UIColor.whiteColor()
        noFound.backgroundColor = UIColor.clearColor()
        
        noFound.center = scrollView.center
        scrollView.addSubview(noFound)
        pageControl.numberOfPages = 0
    }

    private func downloadImageForSearchResult(searchResult: Result, andPlaceOnButton button: UIButton) {
        if let url = searchResult.getArtworkImageURL60() {
            let session = NSURLSession.sharedSession()
            let downloadTask = session.downloadTaskWithURL(url) {
                
                [weak button] url, response, error in
                
                if error == nil, let url = url, data = NSData(contentsOfURL: url), let image = UIImage(data: data){
                    dispatch_async(dispatch_get_main_queue()) {
                        if let button = button {
                            button.setImage(image, forState: .Normal)
                        }
                    }
                }
            }
            downloadTask.resume()
            downloadTasks.append(downloadTask)
        }
    }
    deinit{
        for downloadTask in downloadTasks {
            downloadTask.cancel()
        }
    }
}

extension LandscapeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let width = scrollView.bounds.size.width
        let currentPage = Int((scrollView.contentOffset.x + width/2)/width)
        pageControl.currentPage = currentPage
    }
}

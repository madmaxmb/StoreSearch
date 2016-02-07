//
//  DetailViewController.swift
//  StoreSearch
//
//  Created by Максим on 06.02.16.
//  Copyright © 2016 Maxim. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var artistNameLable: UILabel!
    @IBOutlet weak var kindLable: UILabel!
    @IBOutlet weak var genreLable: UILabel!
    @IBOutlet weak var priceButton: UIButton!
    
    var searchResult: Result!
    var downloadTask: NSURLSessionDownloadTask?
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        modalPresentationStyle = .Custom
        transitioningDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("close"))
        
        view.tintColor = UIColor(red: 20/255, green: 160/255, blue: 160/255, alpha: 1)
        popupView.layer.cornerRadius = 10
        gestureRecognizer.cancelsTouchesInView = false
        gestureRecognizer.delegate = self
        view.addGestureRecognizer(gestureRecognizer)
        
        if searchResult != nil {
            updateUI()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func close() {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func openInStore() {
        if let url = searchResult.getStore() {
            UIApplication.sharedApplication().openURL(url)
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
    
    func updateUI() {
        nameLable.text = searchResult.getName()
        
        if searchResult.getArtistName().isEmpty {
            artistNameLable.text = "Unknown"
        } else {
            artistNameLable.text = searchResult.getArtistName()
        }
        
        kindLable.text = searchResult.getKindForDisplay()
        genreLable.text = searchResult.getGenre()
        
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        formatter.currencyCode = searchResult.getCurrency()
        let priceText: String
        if searchResult.getPrice() == 0 {
            priceText = "Free"
        } else if let text = formatter.stringFromNumber(searchResult.getPrice()) {
            priceText = text
        } else {
            priceText = ""
        }
        priceButton.setTitle(priceText, forState: .Normal)
        
        if let url = searchResult.getArtworkImageURL100() {
            downloadTask = artworkImageView.loadImageWithUrl(url)
        }
    }
    deinit {
        print("deinit \(self)")
        downloadTask?.cancel()
    }

}

extension DetailViewController: UIViewControllerTransitioningDelegate {
    @available(iOS 8.0, *)
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        
        return DimmingPresentationController(presentedViewController: presented, presentingViewController: presenting)
    }
}

extension DetailViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        return (touch.view === self.view)
    }
}
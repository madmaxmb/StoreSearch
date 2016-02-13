//
//  MenuViewController.swift
//  StoreSearch
//
//  Created by Максим on 13.02.16.
//  Copyright © 2016 Maxim. All rights reserved.
//

import UIKit

class MenuViewController: UITableViewController {
    weak var delegate: MenuViewControllerDelegate?
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.row == 0 {
            delegate?.menuViewControllerSendSupportEmail(self)
        }
    }
}

protocol MenuViewControllerDelegate: class {
    func menuViewControllerSendSupportEmail(controller: MenuViewController)
}



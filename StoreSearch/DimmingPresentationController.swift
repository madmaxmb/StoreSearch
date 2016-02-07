//
//  DimmingPresentationController.swift
//  StoreSearch
//
//  Created by Максим on 06.02.16.
//  Copyright © 2016 Maxim. All rights reserved.
//

import UIKit

@available(iOS 8.0, *)
class DimmingPresentationController: UIPresentationController {
    override func shouldRemovePresentersView() -> Bool {
        return false
    }
}

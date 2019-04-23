//
//  SegueHandlerType.swift
//  Check_Lists_swift
//
//  Created by lpiem on 14/03/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//

import UIKit
import Foundation




protocol SegueHandlerType {
    associatedtype SegueIdentifier: RawRepresentable
}

extension SegueHandlerType where Self: UIViewController,
SegueIdentifier.RawValue == String {
    
    // This used to be `performSegueWithIdentifier(...)`.
    func performSegueWithIdentifier(withIdentifier identifier: SegueIdentifier,sender: AnyObject?) {
        
        performSegue(withIdentifier: identifier.rawValue, sender: sender)
    }
    
    func segueIdentifierForSegue(for segue: UIStoryboardSegue) -> SegueIdentifier {
        
        guard let identifier = segue.identifier,
            let segueIdentifier = SegueIdentifier(rawValue: identifier) else { fatalError("Invalid segue identifier \(String(describing: segue.identifier))for view controller of type \(type(of: self)).") }
        
        return segueIdentifier
    }
    
    
}

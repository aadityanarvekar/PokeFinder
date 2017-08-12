//
//  UIViewController+PokeFinder.swift
//  PokeFinder
//
//  Created by AADITYA NARVEKAR on 8/1/17.
//  Copyright © 2017 Aaditya Narvekar. All rights reserved.
//

import UIKit

extension UIViewController {
    func dismissKeyboardOnTapOutside() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
   
}

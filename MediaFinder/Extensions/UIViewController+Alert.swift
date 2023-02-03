//
//  UIViewController+Alert.swift
//  MediaFinder
//
//  Created by Karim Mohamed on 18/12/2022.
//

import UIKit

extension UIViewController{
     func showAlert(title: String, message: String) {
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

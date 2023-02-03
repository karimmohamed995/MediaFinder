//
//  User.swift
//  MediaFinder
//
//  Created by Karim Mohamed on 14/12/2022.
//

import UIKit

struct User: Codable {
    var name: String!
    var email: String!
    var phone: String!
    var password: String!
    var address: String!
    var userImage: CodableImage!
}

struct CodableImage: Codable {
    
    let imageData: Data?
    
    func getImage() -> UIImage? {
        guard let imageData = self.imageData else {return nil}
        return UIImage(data: imageData)
    }
    
    init(withImage image: UIImage) {
        self.imageData = image.jpegData(compressionQuality: 1.0)
    }
}

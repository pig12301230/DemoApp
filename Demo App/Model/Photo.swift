//
//  Photo.swift
//  Demo App
//
//  Created by 莊英祺 on 2019/8/7.
//  Copyright © 2019 Winston. All rights reserved.
//

import Foundation

struct Photo: Decodable {
    var farm: Int
    var secret: String
    var id: String
    var server: String
    var title: String
    var imageUrl: URL {
        return URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_m.jpg")!
    }
}

struct Photos: Decodable {
    var photo: [Photo]
}

struct SearchPhotoData: Decodable {
    var photos: Photos
}

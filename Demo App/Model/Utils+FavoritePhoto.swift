//
//  Utils+FavoritePhoto.swift
//  Demo App
//
//  Created by 莊英祺 on 2019/8/7.
//  Copyright © 2019 Winston. All rights reserved.
//

import Foundation
import CoreData
import RxCoreData
import RxDataSources

func == (lhs: FavoritePhoto, rhs: FavoritePhoto) -> Bool {
    return lhs.title == rhs.title
}

extension FavoritePhoto: Equatable { }
extension FavoritePhoto : IdentifiableType {
    typealias Identity = String
    
    var identity: Identity { return title }
}

extension FavoritePhoto: Persistable {
    static var primaryAttributeName: String {
        return "title"
    }
    
    func update(_ entity: T) {
        entity.setValue(title, forKey: "title")
        entity.setValue(image, forKey: "image")
        
        do {
            try entity.managedObjectContext?.save()
        } catch let error {
            print(error)
        }
    }
    
    typealias T = NSManagedObject
    static var entityName: String { return "FavoritePhoto" }
    
    init(entity: T) {
        title = entity.value(forKey: "title") as! String
        image = entity.value(forKey: "image") as! Data
    }
    
}

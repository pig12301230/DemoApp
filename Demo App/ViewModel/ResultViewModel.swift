//
//  ResultViewModel.swift
//  Demo App
//
//  Created by 莊英祺 on 2019/8/1.
//  Copyright © 2019 Winston. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

protocol ResultViewModel {
    var results: PublishSubject<[Result]> { get }
    func search(content: String,amount: Int)
}

class ResultViewModelImpl: ResultViewModel {
    var results: PublishSubject<[Result]> = PublishSubject()
    
    func search(content: String, amount: Int) {
        // get flickr data
        let apiKey = "34c7daaf58e911043f5dda727ef1dcec"

        let url = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&per_page=\(amount)&text=\(content)&format=json&nojsoncallback=1"
        Alamofire.request(url).responseData { [weak self] (response) in
            guard let self = `self` else {return}
            do {
                let result = try JSONDecoder().decode(SearchPhotoData.self, from: response.result.value!)
                var photos: [Result] = []
                for photo in result.photos.photo {
                    photos.append(Result(name: photo.title, image: photo.imageUrl))
                }
                self.results.onNext(photos)
            } catch let error {
                print(error)
            }
        }
    }
}

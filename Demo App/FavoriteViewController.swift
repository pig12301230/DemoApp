//
//  FavoriteViewController.swift
//  Demo App
//
//  Created by 莊英祺 on 2019/8/7.
//  Copyright © 2019 Winston. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCoreData
import RxDataSources
import CoreData

class FavoriteViewController: UIViewController {
    
    @IBOutlet weak var favoriteCollectionView: UICollectionView!
    var disposeBag = DisposeBag()
    var moc: NSManagedObjectContext! = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    let dataSource =
        RxCollectionViewSectionedAnimatedDataSource<AnimatableSectionModel<String, FavoritePhoto>>(configureCell: { dataSource, collectionView, index, favorite in
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "SearchPhotoCell", for: index) as! SearchPhotoCell
            cell.photoTitle.text = favorite.title
            cell.photoImage.image = UIImage(data: favorite.image)
            return cell
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的最愛"
        favoriteCollectionView.register(UINib(nibName: "SearchPhotoCell", bundle: nil), forCellWithReuseIdentifier: "SearchPhotoCell")
        favoriteCollectionView.rx.setDelegate(self).disposed(by: disposeBag)

        moc.rx.entities(FavoritePhoto.self, predicate: nil, sortDescriptors: nil)
            .map { photos in
                [AnimatableSectionModel(model: "Section 1", items: photos)]
            }
        .bind(to: favoriteCollectionView.rx.items(dataSource: dataSource))
        .disposed(by: disposeBag)
        
        favoriteCollectionView.rx.itemSelected
            .subscribe { [weak self] (item) in
                guard let self = `self` else { return }
                //Delete data
                if let index = item.element, let cell = self.favoriteCollectionView.cellForItem(at: index) as? SearchPhotoCell{
                    self.deleteAction(item: cell)
                }
            }.disposed(by: disposeBag)
    }
    
    private func deleteAction(item: SearchPhotoCell) {
        let alertEvent = UIAlertController(title: "刪除我的最愛", message: "要將這張照片移出我的最愛嗎？", preferredStyle: .alert)
        let delAction = UIAlertAction(title: "確定", style: .default) { (_) in
            // save to CoreData
            if let title = item.photoTitle.text, let imageData = (item.photoImage.image)?.pngData() {
                let photo = FavoritePhoto(title: title, image: imageData)
                do {
                    try self.moc.rx.delete(photo)
                } catch let error {
                    print(error)
                }
            } else {
                print("Data Delete Failed")
            }
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertEvent.addAction(delAction)
        alertEvent.addAction(cancelAction)
        present(alertEvent, animated: true)
    }
}

extension FavoriteViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let cellWidth = (width - 30) / 3 // compute your cell width
        return CGSize(width: cellWidth, height: cellWidth * 1.3)
    }
}

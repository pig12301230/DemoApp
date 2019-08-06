//
//  ResultViewController.swift
//  Demo App
//
//  Created by 莊英祺 on 2019/8/1.
//  Copyright © 2019 Winston. All rights reserved.
//

import UIKit
import RxSwift
import Kingfisher
import CoreData
import RxCoreData

class ResultViewController: UIViewController {
    var content: String!
    var amount: Int = 0
    let resultViewModel:ResultViewModel = ResultViewModelImpl()
    var moc: NSManagedObjectContext! = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var resultCollectionView: UICollectionView!
    //key 34c7daaf58e911043f5dda727ef1dcec
    //key 4821914ae792317c
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "搜尋結果 \(content!)"
        resultCollectionView.register(UINib(nibName: "SearchPhotoCell", bundle: nil), forCellWithReuseIdentifier: "SearchPhotoCell")
        resultCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        resultViewModel.search(content: content, amount: amount)
        
        resultViewModel.results.asObserver()
            .bind(to: resultCollectionView.rx.items) { (collectionview, row, element) in
                let indexPath = IndexPath(row: row, section: 0)
                let cell = collectionview.dequeueReusableCell(withReuseIdentifier: "SearchPhotoCell", for: indexPath) as! SearchPhotoCell
                cell.photoTitle.text = element.name
                cell.photoImage.kf.setImage(with: element.image)
                return cell
        }.disposed(by: disposeBag)
        
        resultCollectionView.rx.itemSelected
            .subscribe { [weak self] (item) in
                guard let self = `self` else { return }
                //save Result
                if let index = item.element, let cell = self.resultCollectionView.cellForItem(at: index) as? SearchPhotoCell{
                    self.saveAction(item: cell)
                }
            }.disposed(by: disposeBag)
    }
    
    private func saveAction(item: SearchPhotoCell) {
        let alertEvent = UIAlertController(title: "加到我的最愛", message: "要將這張照片存入我的最愛嗎？", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "確定", style: .default) { (_) in
            // save to CoreData
            if let title = item.photoTitle.text, let imageData = (item.photoImage.image)?.pngData() {
                let photo = FavoritePhoto(title: title, image: imageData)
                do {
                    try self.moc.rx.update(photo)
                } catch let error {
                    print(error)
                }
            } else {
                print("Data Save Failed")
            }
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertEvent.addAction(saveAction)
        alertEvent.addAction(cancelAction)
        present(alertEvent, animated: true)
    }
}

extension ResultViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let cellWidth = (width - 30) / 3 // compute your cell width
        return CGSize(width: cellWidth, height: cellWidth * 1.3)
    }
}


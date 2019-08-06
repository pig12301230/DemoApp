//
//  ViewController.swift
//  Demo App
//
//  Created by 莊英祺 on 2019/8/1.
//  Copyright © 2019 Winston. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {

    @IBOutlet weak var contentTextField: UITextField!
    @IBOutlet weak var contentCountTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    let disposeBag = DisposeBag()
    let searchViewModel = SearchViewModelImpl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //init TextField
        self.title = "搜尋輸入頁"
        contentTextField.placeholder = "欲搜尋內容"
        contentTextField.borderStyle = .line
        contentCountTextField.placeholder = "每頁呈現數量"
        contentCountTextField.borderStyle = .line
        
        bindButtonEnabled()
        
        searchButton.rx
            .tap
            .bind(onNext: { [weak self] in
                guard let self = `self` else { return }
                guard let count = Int(self.contentCountTextField.text!) else { return self.showAlert() }
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "Result") as! ResultViewController
                vc.amount = count
                vc.content = self.contentTextField.text!
                self.navigationController?.pushViewController(vc, animated: true)
            }).disposed(by: disposeBag)
    }
    
    func showAlert() {
        let alertEvent = UIAlertController(title: "格式錯誤", message: "數量請輸入數字", preferredStyle: .alert)
        let action = UIAlertAction(title: "知道了", style: .default, handler: nil)
        alertEvent.addAction(action)
        present(alertEvent, animated: true)
    }
    
    func bindButtonEnabled(){
        let contentValidation = contentTextField.rx
            .text
            .map({!$0!.isEmpty})
            .share(replay: 1)
        
        let contentCountValidation = contentCountTextField.rx
            .text
            .map({!$0!.isEmpty})
            .share(replay: 1)
        
        let enableButton = Observable.combineLatest(contentValidation, contentCountValidation) { (content, count) in
            return content && count
        }
        
        enableButton
            .bind(to: searchButton.rx.valid)
            .disposed(by: disposeBag)
    }
    
}

extension Reactive where Base : UIButton {
    public var valid : Binder<Bool> {
        return Binder(self.base) { button, valid in
            button.isEnabled = valid
            if valid {
                button.backgroundColor = .blue
            } else {
                button.backgroundColor = .lightGray
            }
        }
    }
}

//
//  ViewController.swift
//  Assessment
//
//  Created by Sushil K Mishra on 15/02/23.
//

import UIKit

class ViewController<DataProcessor: ViewModel>: UIViewController {
    //MARK:- Vars
    var viewModel: DataProcessor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}

extension UIViewController {

       func updateTitleBackStyle(){
           let yourBackImage = UIImage(named: "back")
           navigationController?.navigationBar.backIndicatorImage = yourBackImage
           navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
           navigationController?.navigationBar.backItem?.title = ""
           navigationController?.navigationBar.tintColor = UIColor.black
           navigationController?.navigationBar.barTintColor = UIColor.white
           let attributes = [NSAttributedString.Key.font: FontAttribute.getFontNameWithSize(type: .bold, size: 24.0), NSAttributedString.Key.foregroundColor:UIColor.black]
           navigationController?.navigationBar.titleTextAttributes = attributes
       }

   }

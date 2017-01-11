//
//  ViewController.swift
//  gif_image_view
//
//  Created by scm197 on 1/11/17.
//  Copyright © 2017 scm197. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

 
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
            super.init(nibName: nil , bundle: nil)
            setupViews();
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }


    func setupViews()
    {
        self.view.backgroundColor = UIColor.white
        
    }
   
}


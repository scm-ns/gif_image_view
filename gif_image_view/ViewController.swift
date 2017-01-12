//
//  ViewController.swift
//  gif_image_view
//
//  Created by scm197 on 1/11/17.
//  Copyright © 2017 scm197. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let imageView = UIImageView()
    
    
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
        
        // Animate Image Vie
       // self.imageView.image = UIImage.animatedImageWithGIFURL(url:(URL(string:"http://i.giphy.com/BtKpPw1u29TnW.gif")! as NSURL))
        self.imageView.image = UIImage.animatedImageWithGIFURL(url:(URL(string:"http://i.giphy.com/gsYKROakiJQPu.gif")! as NSURL))
        
    }


    func setupViews()
    {
        self.view.backgroundColor = UIColor.white
        
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
      
        // View to hierachy + constraints
        self.view.addSubview(self.imageView)
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[v0]-8-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": self.imageView]))
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-50-[v0]-50-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": self.imageView]))

    }
   
   
    
    
}


//
//  ViewController.swift
//  gif_image_view
//
//  Created by scm197 on 1/11/17.
//  Copyright © 2017 scm197. All rights reserved.
//

import UIKit

class MainViewController: UICollectionViewController
{
    static let cellId = "cell_1"
    convenience init()
    {
            let layout = UICollectionViewFlowLayout()
            self.init(collectionViewLayout: layout)
    }
    
    override init(collectionViewLayout layout: UICollectionViewLayout)
    {
        super.init(collectionViewLayout: layout)
        setupViews()
        self.collectionView?.register(GifCell.self, forCellWithReuseIdentifier:MainViewController.cellId)
    }
   
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Animate Image Vie
       // self.imageView.image = UIImage.animatedImageWithGIFURL(url:(URL(string:"http://i.giphy.com/BtKpPw1u29TnW.gif")! as NSURL))
        //self.imageView.image = UIImage.animatedImageWithGIFURL(url:(URL(string:"http://1.images.comedycentral.com/images/tve/daily_show_trevor_noah/DailyShow_Trevor_BreakingNews2_408x408.gif")! as NSURL))
        
    }

    func setupViews()
    {
        self.view.backgroundColor = UIColor.green
      
    }
   
}

class MainDataSource : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainViewController.cellId , for: indexPath) as! GifCell
            return cell
    }
    
    

}

}

}

}


/// Shown inside the Main Collection View
/// Holds another Collection view inside it
class GifCell : UICollectionViewCell
{
    let collectionView =
    { () -> UICollectionView in
            let colView = UICollectionView()
            return colView
    }()
    
    override init(frame: CGRect)
    {
            super.init(frame : frame)
            self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews()
    {
        self.addSubview(collectionView)
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[v0]-8-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":collectionView]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[v0]-8-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":collectionView]))
    }
    
}

/// Holds the GIF : Shown inside the GifCell 
class GifSubCell : UICollectionViewCell
{
    let imageView : UIImageView = {
        let vi = UIImageView()
        vi.tintColor = UIColor.red
        return vi
    }()
    
    override init(frame: CGRect) {
        super.init(frame : frame)
        self.setupViews()
    }
   
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    func setupViews()
    {
        self.addSubview(imageView)
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[v0]-8-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":imageView]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[v0]-8-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":imageView]))
    }
}


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
    let dataSource : MainDataSource!
    convenience init()
    {
            let layout = UICollectionViewFlowLayout()
            self.init(collectionViewLayout: layout)
    }
    
    override init(collectionViewLayout layout: UICollectionViewLayout)
    {
        self.dataSource = MainDataSource()
        super.init(collectionViewLayout: layout)
        setupViews()
        self.collectionView?.register(GifCell.self, forCellWithReuseIdentifier:GifCell.cellId)
        self.collectionView?.dataSource = self.dataSource
        self.collectionView?.delegate =  self.dataSource
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
        self.collectionView?.backgroundColor = UIColor.green
    }
   
}

class MainDataSource : NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    // How to decide on number of Cells to display
    var composedDataSources : [GifCellDataSource] = [GifCellDataSource() , GifCellDataSource() , GifCellDataSource() ,
                                                     GifCellDataSource() , GifCellDataSource() , GifCellDataSource()]
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GifCell.cellId, for: indexPath) as! GifCell
            cell.setDataSourceAndDelegate(dataSource: composedDataSources[indexPath.row])
            return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  composedDataSources.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: CGFloat(indexPath.row * 100) )
    }
}

/// Shown inside the Main Collection View
/// Holds another Collection view inside it
class GifCell : UICollectionViewCell
{
    static let cellId = "gif_cell"
    var dataSource : GifCellDataSource!
    lazy var collectionView : UICollectionView = {
        [unowned self]  in
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            //let colFrame =  CGRect(x: self.frame.origin.x, y: self.frame.origin.y , width: self.frame.width - 20, height: self.frame.height - 50)
            // CGSize(width: self.frame.width - 20, height: self.frame.height - 50 )
            let colView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
            return colView
    }()
    
    override init(frame: CGRect)
    {
            self.dataSource = nil
            super.init(frame : frame)
            self.setupViews()
            self.collectionView.register(GifSubCell.self, forCellWithReuseIdentifier: GifSubCell.cellId)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    // To be set up when the cell is dequed to be displayed
    func setDataSourceAndDelegate(dataSource : GifCellDataSource)
    {
        self.dataSource = dataSource
        self.collectionView.dataSource = self.dataSource
        self.collectionView.delegate = self.dataSource
        self.collectionView.reloadData()
    }

    private func setupViews()
    {
        self.addSubview(collectionView)
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView.backgroundColor = UIColor.red
        self.collectionView.alwaysBounceHorizontal = true
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[v0]-8-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":collectionView]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[v0]-8-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":collectionView]))
    }
    
}


class GifCellDataSource : NSObject, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout
{
    var URLStringArray : [String] = []
    
    override init()
    {
       super.init()
        URLStringArray.append("http://1.images.comedycentral.com/images/tve/daily_show_trevor_noah/DailyShow_Trevor_BreakingNews2_408x408.gif")
        URLStringArray.append("http://1.images.comedycentral.com/images/tve/daily_show_trevor_noah/DailyShow_Trevor_IDontThinkSo_408x408.gif")
        URLStringArray.append("http://1.images.comedycentral.com/images/tve/daily_show_trevor_noah/DailyShow_Trevor_WaitFinger_Animated_408x408.gif")
        URLStringArray.append("http://1.images.comedycentral.com/images/tve/daily_show_trevor_noah/DailyShow_Trevor_Wrong_Animated_408x408.gif")
        URLStringArray.append("http://1.images.comedycentral.com/images/tve/at_midnight/AtMidnight_ChrisHardwick_Points_408x408.gif")
        URLStringArray.append("http://1.images.comedycentral.com/images/tve/daily_show_trevor_noah/DailyShow_Trevor_Wrong_Animated_408x408.gif")
        URLStringArray.append("http://1.images.comedycentral.com/images/tve/at_midnight/AtMidnight_ChrisHardwick_Points_408x408.gif")
        URLStringArray.append("http://1.images.comedycentral.com/images/tve/south_park/SouthPark_Cartman_ScrewYouGuys_408x408.gif")
        URLStringArray.append("http://1.images.comedycentral.com/images/tve/another_period/AnotherPeriod_Beatrice_Finally_Animated_408x408.gif")
    }
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return URLStringArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GifSubCell.cellId, for: indexPath) as! GifSubCell
            //let image = UIImage.animatedImageWithGIFURL(string: URLStringArray[indexPath.row])
            cell.setImage(gifURLStr: URLStringArray[indexPath.row])
        
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height , height: collectionView.frame.height )
    }
    
    
} 


/// Holds the GIF : Shown inside the GifCell 
class GifSubCell : BaseCell
{
    static let cellId = "gif_sub_cell"
    private let imageView : FLAnimatedImageView = {
        let vi = FLAnimatedImageView()
        vi.tintColor = UIColor.red
        return vi
    }()
   
    override func prepareForReuse() {
        self.imageView.image = nil
    }
  
    func setImage(gifURLStr : String)
    {
        let url = NSURL(string: gifURLStr)
        
        DispatchQueue.global(qos: .utility).async
        {
            let image: FLAnimatedImage = FLAnimatedImage(animatedGIFData: NSData(contentsOf: url as! URL) as Data!)
            DispatchQueue.main.async
            {
                    self.imageView.animatedImage = image
            }
        }
    }
    
    override func setupViews()
    {
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageView)
        self.imageView.contentMode = .scaleToFill
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[v0]-8-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":imageView]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[v0]-8-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":imageView]))
    }

}


class BaseCell : UICollectionViewCell
{
    override init(frame: CGRect) {
        super.init(frame : frame)
        self.setupViews()
    }
   
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    
    func setupViews()
    {
        
    }
}

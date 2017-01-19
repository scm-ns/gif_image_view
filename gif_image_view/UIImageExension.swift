//
//  UIImageExension.swift
//  gif_image_view
//
//  Created by scm197 on 1/11/17.
//  Copyright © 2017 scm197. All rights reserved.
//
import UIKit
import ImageIO

extension UIImage
{
    ///
    /// Returns an Animated UIImage with GIF at the given URL. Set it as UIImageView.image to see the GIF
    /// Gets an Animated UIImage from the (animated) GIF at the given URL. Accepts a completion handler where the image is passed.
    /// Set the image as UIImageView.image within the completion handler to see the GIF. 
    /// Heavy Lifting done on a utility queue, but the completion executed on the main thread
    /// 
    /// Details :
    ///  UIImage has property images which is an array of images. This array is filled using a convenice method
    ///  This sequence of images is iterated through by the ImageView giving the apperance of a GIF
    ///  Move Everything into the background thread.
    ///  Add a completion block that will give the image to the completion block and the user can choose to use the image.
    /// 
    /// - Parameter url: url pointing to the gif
    /// - Completion Handler : Used to update the image. Run on the Main Thread
    class func animatedImageWithGIFURL(string : String , completion : @escaping (UIImage!) -> Void ) // no argument label for closure in swift 3
    {
        
        DispatchQueue.global(qos : .utility).async
        {
            // Get the ImageSource for a network request (synchronously)
            let imageSource : CGImageSource = CGImageSourceCreateWithURL(URL(string: string) as! CFURL, nil)!
            
            // Get the images in the gif from the image source and convert them into CGImage ArrayLw
            let cgImageArray : [CGImage] = CGImageArray(imageSource: imageSource)
            
            // get the delay associated with the gif from the image source
            // Each delay value correspods to the number of time steps that a particular image should be shown for
            // The duration can be variable according to gif standard. [ie some images shown longer than others]
            let delayArray : [Int] = DelayArray(imageSource: imageSource)
       
            print(delayArray)
            
            // Sum up the total duration of the gif 
            // Uses the Operator Methods Closure
            let duration = delayArray.reduce(0 , +)

            // Get an array of images where based on the delay for each frame, the frame is repeated in the array. 
            // So an image with a delay lasting 5 time steps will be repeated (copied) in the array 5 times
            let uiImageArray : [UIImage] = UIImageFrames(CGImageArray: cgImageArray , DelayArray: delayArray , duration: Double(duration))
          
            // UIImage has a property for holding an array of images, which can be animated.
            let uiImage = UIImage.animatedImage(with: uiImageArray, duration: TimeInterval(duration/100))
            // Not a single image but an array of image lives in a single UIImage instance here.
    
            DispatchQueue.main.async
            {
                completion(uiImage)
            }
            
        }
       
    }
   
    // Extract the images from the imageSource and store it in an array
    class private func CGImageArray(imageSource : CGImageSource ) -> [CGImage]
    {
        let numImages = CGImageSourceGetCount(imageSource)
        var CGImageArray : [CGImage] = []
        
        for imageIdx in 0..<numImages
        {
            CGImageArray.append(CGImageSourceCreateImageAtIndex(imageSource, imageIdx, nil)!)
        }
        
        return CGImageArray
    }
    
    
    class private func DelayArray(imageSource : CGImageSource) -> [Int]
    {
        let numImages = CGImageSourceGetCount(imageSource)
        
        var delayArray : [Int] = []
        for imageIdx in 0..<numImages
        {
            delayArray.append(delayAtIndex(imageSource: imageSource, index: imageIdx)!)
        }
        
        return delayArray
    }
    
    class private func delayAtIndex(imageSource : CGImageSource , index : Int) ->Int?
    {
        let properties  = CGImageSourceCopyPropertiesAtIndex(imageSource, index, nil) as! Dictionary<String, Any>
    
        let gif = properties[String(kCGImagePropertyGIFDictionary)] as! Dictionary<String , Double>
       
        var delay : Double? = gif[String(kCGImagePropertyGIFUnclampedDelayTime)]
        print(gif)
        if(delay == nil || delay == 0)
        {
                delay = gif[String(kCGImagePropertyGIFDelayTime)]
        }
        
        if let delay = delay
        {
            print(delay)
            return lround(delay * 100);
        }
        else
        {
            return 1;
        }
        
    }
   

    class private func greatestCommonDivisor( valA : Int , valB : Int) -> Int
    {
        // Due to Parameter Immutability
        var a = valA;
        var b = valB;
        
        if( a > b)
        {
            swap(&a , &b)
        }
        
        while(true)
        {
            let r = a % b
            if (r == 0)
            {
                return b
            }
            a = b
            b = r
        }

    }
    
    
   
    /// Creates the UIImageArray using the CGImages and Delay Array
    ///
    /// In GIF's different frames have differents durations. Some Frames are shown for longer or shorter than the rest
    /// Essentially variable durations
    /// But GIF being a compressed format only stores one copy of the frame for the entire duration
    /// So we have to repeat a given image multiple times to simulate the effect of variable durations
    /// The greatest commonn divisor is used the determine the step size
    ///
    ///  gcd = []  ; 1 ,2, 3 = images ; |     | = duration for a single frame
    ///
    ///  |     1   |   2  |         3       |
    ///  [][][][][]  [][][] [][][][][][][][]
    ///      1         2            3
    ///     image
    ///   repeated
    ///   for each
    ///     step
    ///
    /// - Parameters:
    ///   - CGImageArray: 
    ///   - DelayArray: <#DelayArray description#>
    ///   - duration: <#duration description#>
    /// - Returns: <#return value description#>
    class private func UIImageFrames( CGImageArray : [CGImage] , DelayArray : [Int] , duration : Double) -> [UIImage]
    {
        
        var UIImageArray: [UIImage] = []
        
        let greatestCommonDiv = DelayArray.reduce(0, greatestCommonDivisor)
       
        for imageArrayIdx in 0..<CGImageArray.count
        {
            let uiImage : UIImage = UIImage(cgImage: CGImageArray[imageArrayIdx])
            let numRepreatedFrames = DelayArray[imageArrayIdx] / greatestCommonDiv
            
            for _ in 0..<numRepreatedFrames
            {
                    UIImageArray.append(uiImage)
            }
        }
        print(UIImageArray.count)
        return UIImageArray
    }
    
}

















      

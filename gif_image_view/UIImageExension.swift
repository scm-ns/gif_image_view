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
    /// Returns an Animated UIImage with GIF at the given URL. Set it as UIImageView.image to see the GIF
    ///
    /// Details :
    ///  UIImage has property images which is an array of images. This array is filled using a convenice method
    ///  This sequence of images is iterated through by the ImageView giving the apperance of a GIF
    ///
    /// - Parameter url: url pointing to the gif
    /// - Returns: Animated UIImage
    class func animatedImageWithGIFURL(url:NSURL) -> UIImage
    {
        let imageSource : CGImageSource = CGImageSourceCreateWithURL(url, nil)!
       
        
        let cgImageArray : [CGImage] = CGImageArray(imageSource: imageSource)
        
        let delayArray : [Int] = DelayArray(imageSource: imageSource)
    
        let duration = delayArray.reduce(0 , +)
        
        let uiImageArray : [UIImage] = UIImageFrames(CGImageArray: cgImageArray , DelayArray: delayArray , duration: Double(duration))
       
        let uiImage = UIImage.animatedImage(with: uiImageArray, duration: TimeInterval(duration))
        
        return uiImage!
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
        let properties : CFDictionary! = CGImageSourceCopyPropertiesAtIndex(imageSource, index, nil)
       
        let gifPropertyKey : UnsafeRawPointer! = unsafeBitCast(kCGImagePropertyGIFDictionary, to: UnsafeRawPointer.self)
           
        // returns a ptr
        let gifPropertyRawPtr : UnsafeRawPointer! = CFDictionaryGetValue(properties, gifPropertyKey)
          
        // convert the ptr to UnSafePointer
        let gifPropertyPtr : UnsafePointer<CFDictionary> = gifPropertyRawPtr.assumingMemoryBound(to: CFDictionary.self)

        // Get the type from the UnSafe Pointer
        let gifProperty : CFDictionary! = gifPropertyPtr.pointee as? CFDictionary
          
        var delayPropertyKey : UnsafeRawPointer! = unsafeBitCast(kCGImagePropertyGIFUnclampedDelayTime, to: UnsafeRawPointer.self)
                
        var delayPropertyRawPtr : UnsafeRawPointer! = CFDictionaryGetValue(gifProperty , delayPropertyKey)
        
        var delayPropertyPtr : UnsafePointer<NSNumber> = delayPropertyRawPtr.assumingMemoryBound(to: NSNumber.self)
 
        var delayNSNumber : NSNumber? = delayPropertyPtr.pointee
        
            if delayNSNumber == nil || delayNSNumber?.doubleValue == 0
            {
                // Obtain the value from a different feild in the dict
             
                delayPropertyKey = unsafeBitCast(kCGImagePropertyGIFDelayTime, to: UnsafeRawPointer.self)
                delayPropertyRawPtr = CFDictionaryGetValue(gifProperty , delayPropertyKey)
                delayPropertyPtr = delayPropertyRawPtr.assumingMemoryBound(to: NSNumber.self)
                delayNSNumber = delayPropertyPtr.pointee
                
            }
                
            // GIF format stores the data in centiseconds(0.01 seconds), which is needed for organizing the frames
            // ImageIO converts it into seconds, but we need it in centiseconds for operating on it.
            if let delayNSNumber = delayNSNumber
            {
                return Int(Double(delayNSNumber.doubleValue) * Double(100.0) );
            }
            else
            {
                return 100;
            }
            
        return nil;
    }
   

    class private func greatestCommonDivisor( valA : Int , valB : Int) -> Int
    {
        // Due to Parameter Immutability
        var a = valA;
        var b = valB;
        
        if( a < b)
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
    ///   - CGImageArray: <#CGImageArray description#>
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
        
        return UIImageArray
    }
    
}

















      

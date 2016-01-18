//
//  DetailViewController.swift
//  Flicks
//
//  Created by Oranuch on 1/14/16.
//  Copyright © 2016 horizon. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoView: UIView!

    var movie: NSDictionary!
    let bottomFrameCoord = UIWindow(frame: UIScreen.mainScreen().bounds).frame.height
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.hidden = true
//        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + 200)
        
        let title = movie["title"] as? String
        titleLabel.text = title
        
        // set detail view's title to the selected movie's title
        self.navigationItem.title = title
        
        let overview = movie["overview"]
        overviewLabel.text = overview as? String
        overviewLabel.sizeToFit()
        
         let baseUrl = "http://image.tmdb.org/t/p/w500"
        
        // check if nil or not
        if let posterPath = movie["poster_path"] as? String {
            let imageUrl = NSURL(string: baseUrl + posterPath)
            //posterImageView.setImageWithURL(imageUrl!)
            
            //load low resolution image first then larger image
            let baseUrlSmall = "http://image.tmdb.org/t/p/w92"
            let imageUrlSmall = NSURL(string: baseUrlSmall + posterPath)
            let smallImageRequest = NSURLRequest(URL: imageUrlSmall!)
            let largeImageRequest = NSURLRequest(URL: imageUrl!)
            
            posterImageView.setImageWithURLRequest(smallImageRequest,
                placeholderImage: nil ,
                success: { (smallImageRequest, smallImageResponse, smallImage) -> Void in
                    self.posterImageView.alpha = 0.0
                    self.posterImageView.image = smallImage
                    self.posterImageView.contentMode = .ScaleAspectFit
                    
                    UIView.animateWithDuration(0.3, animations: { self.posterImageView.alpha = 1.0 },
                        completion: { (success) -> Void in
                            self.posterImageView.setImageWithURLRequest(largeImageRequest,
                                placeholderImage: smallImage,
                                success: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                                    self.posterImageView.image = largeImage
                                }, failure: { (request, response, error ) -> Void in
                                    //self.posterImageView.image = UIImage(named: "MovieHolder")
                            })
                        }
                    )
                }, failure: {(request, response, error) -> Void in
                    //self.posterImageView.image = UIImage(named: "MovieHolder")
                }
            )

        }
        
        
        
       
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTapped(sender: AnyObject) {
        // toggle info view
        //infoView.hidden = infoView.hidden == true ? false : true
        
        let yCoord = self.infoView.frame.origin.y
        let offset: CGFloat = yCoord >= bottomFrameCoord ? -infoView.frame.height : infoView.frame.height
        
        UIView.animateWithDuration(0.4, animations: {
            self.infoView.frame.origin.y = yCoord + offset
        })
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

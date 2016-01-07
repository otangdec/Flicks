//
//  MoviesViewController.swift
//  Flicks
//
//  Created by Oranuch on 1/5/16.
//  Copyright © 2016 horizon. All rights reserved.
//

import UIKit
import AFNetworking // clean and build to make it work correctly
import SVProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITabBarDelegate, UISearchBarDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var movieSearchBar: UISearchBar!
    @IBOutlet weak var networkErrorView: UIView!

    var movies: [NSDictionary]? // optional can be dict or nil, safer
    var allMovies: [NSDictionary]?
    
    var refreshControl: UIRefreshControl!
    var filteredData: [NSDictionary]?
    

    
    // Do any additional setup after loading the view.
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        movieSearchBar.delegate = self
        
        self.networkErrorView.hidden = true
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self,action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
        
        fetchMovieApi()
    }
    
    func refresh(sender:AnyObject){
        fetchMovieApi()
        self.refreshControl.endRefreshing()
    }

    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Change the status bar to light color
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    // Call movie api to get list of movies
    func fetchMovieApi(){
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = NSURLRequest(URL: url!)
        
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        SVProgressHUD.show()
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                
                SVProgressHUD.dismiss()
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            print("response: \(responseDictionary)")
                            
                            self.movies = responseDictionary["results"] as? [NSDictionary]
                            self.allMovies = self.movies!
                            self.tableView.reloadData()
                    } else {
                        self.networkErrorView.hidden = false
                    }
                }
        });
        task.resume()
    }
    
    // set up table views
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        if let movies = movies{
            return movies.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        
        // ! menas the optional will not be nil
        let movie = movies![indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        let posterPath = movie["poster_path"] as! String

        let baseUrl = "http://image.tmdb.org/t/p/w500"
        let imageUrl = NSURL(string: baseUrl + posterPath)
        
        
        cell.posterView.setImageWithURL(imageUrl!)
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
    
     
        print("row \(indexPath.row)")
    
        
        return cell
    }
    
    /* ----------------------------- Search Bar ----------------------------- */
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.setShowsCancelButton(true, animated: true)
        if(searchText.isEmpty) {
            movies = movies!
            searchBar.endEditing(true)
        } else {
            movies = movies!.filter {
                let name = $0["title"] as! String
                return name.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
            }
        }
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }

    func searchBarTextDidEndEditing(searchBar: UISearchBar){
        movies = allMovies
        tableView.reloadData()
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBarTextDidEndEditing(searchBar)
        searchBar.endEditing(true)
        searchBar.text = ""
    }
    

    /* ----------------- saved code for future references ---------------------
    //add delay
    func delay(delay:Double, closure: () -> ()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure
        )
    }
    
    usage:
    self.delay(3.0){ SVProgressHUD.show() }
    self.delay(5.0) { SVProgressHUD.dismiss() }

    */
    
}
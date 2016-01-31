//
//  MoviesViewController.swift
//  Flicks
//
//  Created by Oranuch on 1/5/16.
//  Copyright © 2016 horizon. All rights reserved.
//

import UIKit
import SVProgressHUD
import AFNetworking // clean and build to make it work correctly


class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITabBarDelegate, UISearchBarDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var movieSearchBar: UISearchBar!
    @IBOutlet weak var networkErrorView: UIView!
    @IBOutlet weak var languageLabel: UILabel!


    var movies: [NSDictionary]? // optional can be dict or nil, safer
    var allMovies: [NSDictionary]?
    var idCasts: [String: [String]]? = Dictionary<String, [String]>()
    var genreNames: [String: [String]]? = Dictionary<String, [String]>()
    var languagesDict: [String: [String]]? = Dictionary<String, [String]>()
    
    var refreshControl: UIRefreshControl!
    var filteredData: [NSDictionary]?
    var placeholderImage = UIImage(contentsOfFile: "flicks-logo")
    
    var endpoint: String!
    
    var rightSearchBarButtonItem:UIBarButtonItem!
    var leftNavBarButton: UIBarButtonItem!
    var changeViewBarButton: UIBarButtonItem!
    
    var collectionImage = UIImage(named: "collection")
    var hamburgerImage = UIImage(named: "hamburger")

    
    // Do any additional setup after loading the view.
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self

        
        self.networkErrorView.hidden = true
        
        // Set up the Movie Search Bar
        initializeMovieSearchBar()
        movieSearchBar.tintColor = UIColor.whiteColor()
        
        // Set up the refresh control for pull to refresh
        initializeRefreshControl()
        
        // Set up the customize navigation bar
        initializeNavBar()
        
        // call Movie api to retrieve movie information
        networkRequest()
        
    }
    
    func initializeMovieSearchBar(){
        movieSearchBar.delegate = self
        movieSearchBar.searchBarStyle = UISearchBarStyle.Minimal
        //movieSearchBar.alpha = 0
        movieSearchBar.hidden = true
    }

    func initializeRefreshControl(){
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self,action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
    }
    
    func refresh(sender:AnyObject){
        networkRequest()
        self.refreshControl.endRefreshing()
    }
    
    func initializeNavBar(){
        
        // Set Title of the page according to the activated tab
        if tabBarController?.selectedIndex == 0{
            self.navigationItem.title = "Now Playing"
        } else if tabBarController?.selectedIndex == 1 {
            self.navigationItem.title = "Top Rated"
        }
        
        // Make search button and add into the navagation bar on the right
        rightSearchBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Search, target: self, action: "searchTapped:")
        self.navigationItem.rightBarButtonItem = rightSearchBarButtonItem
        
        // make search bar into a UIBarButtonItem
        leftNavBarButton = UIBarButtonItem(customView:movieSearchBar)
        
        // add button to toggle between collection view and table view
        changeViewBarButton = UIBarButtonItem(image: collectionImage, style: UIBarButtonItemStyle.Plain, target: self, action: "changeView")
        self.navigationItem.leftBarButtonItem = changeViewBarButton
        
        // set back button with title "Back"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: nil, action: nil)
    }
    
    func changeView(){

        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = false
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
    func networkRequest(){
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string:"https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
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
                            //print("response: \(responseDictionary)")
                            
                            self.movies = responseDictionary["results"] as? [NSDictionary]
                            self.allMovies = self.movies!
                            
                            for movie in self.movies! {
                                self.requestCredit(movie["id"] as! Int)
                                self.requestID(movie["id"] as! Int)
                            }
                            self.tableView.reloadData()
                            
                    }
                } else {
                    self.networkErrorView.hidden = false
                }
        
        });
        task.resume()
    }
    
    func requestCredit(movieId: Int){
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string:"https://api.themoviedb.org/3/movie/\(movieId)/credits?api_key=\(apiKey)")
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
                            //assign cast to movie id: ["3234":"john, jill"]
                            
                            let allCasts = responseDictionary.valueForKeyPath("cast") as! NSArray
                            let castNames = allCasts.map{ $0.valueForKeyPath!("name") as! String }
                    
                            self.idCasts?.updateValue(castNames, forKey: String(movieId))
                            self.tableView.reloadData()
                    }
                } else {
                    self.networkErrorView.hidden = false
                }
                
        });
        task.resume()

    }
    
    func requestID(movieId: Int){
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string:"https://api.themoviedb.org/3/movie/\(movieId)?api_key=\(apiKey)")
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
                            let allGenre = responseDictionary.valueForKeyPath("genres") as! NSArray
                            let genreNames = allGenre.map{ $0.valueForKeyPath!("name") as! String }
                            
                            let allLanguages = responseDictionary.valueForKey("spoken_languages") as! NSArray
                            let languages = allLanguages.map{ $0.valueForKeyPath!("name") as! String }
                            
                            self.genreNames?.updateValue(genreNames, forKey: String(movieId))
                            self.languagesDict?.updateValue(languages, forKey: String(movieId))
                            
                            
                            self.tableView.reloadData()
                    }
                } else {
                    self.networkErrorView.hidden = false
                }
                
        });
        task.resume()
        
    }
    
    
    /* ------------------------------- Table View ---------------------------- */
    
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
        
        // Change the highlighted color of selected cell
        let backgroundView = UIView()
//        backgroundView.backgroundColor = UIColor.orangeColor()
        backgroundView.backgroundColor = UIColor(red: 252/255, green: 135/255, blue: 0/255, alpha: 0.5)
        cell.selectedBackgroundView = backgroundView
        
        
        // ! menas the optional will not be nil
        let movie = movies![indexPath.row]
        let title = movie["title"] as! String
        //let language = movie["original_language"] as! String
        let languageList = self.languagesDict![String(movie.valueForKey("id")!)]

        let casts = self.idCasts![ String(movie.valueForKey("id")!) ]
        
        let genreList = self.genreNames![String(movie.valueForKey("id")!)]
        
        let releaseDate = movie["release_date"] as! String
        let vote = movie["vote_average"] as! Double
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        
        if let posterPath = movie["poster_path"] as? String {
        
            let imageUrl = NSURL(string: baseUrl + posterPath)
            let request = NSURLRequest(URL: imageUrl!)

            cell.posterView.setImageWithURLRequest(request, placeholderImage: placeholderImage, success: { (request, response, imageData) -> Void in
                UIView.transitionWithView(cell.posterView, duration: 1.0, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { cell.posterView.image = imageData }, completion: nil   )
                }, failure: nil)
            cell.titleLabel.text = title
            //cell.overviewLabel.text = overview
            
            if languageList != nil{
                let languageString = (languageList?.joinWithSeparator(","))
                cell.languageLabel.text = "Language: \(languageString!)"
            } else {
                cell.languageLabel.text = "Unspecified"
            }
            
            if casts != nil {
                cell.castNamesLabel.text = "\(casts![0]), \(casts![1])"
            } else {
                cell.castNamesLabel.text = ""
            }
            

            if genreList != nil {
                let genreString = (genreList?.joinWithSeparator(" ,"))!
                cell.genresLabel.text = genreString
            } else {
                cell.genresLabel.text = "Unspecified"
            }
            cell.releaseDateLabel.text = "Released: \(releaseDate)"
            cell.voteLabel.text = "\(vote*10)%"

            
        }

    
        return cell
    }
    

    /* ----------------------------- Search Bar ----------------------------- */
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.setShowsCancelButton(true, animated: true)
        
        movies = searchText.isEmpty ? allMovies : allMovies!.filter({ (movie: NSDictionary) -> Bool in
            return (movie["title"] as! String).rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
        })
        tableView.reloadData()
    }
    
    //MARK: UISearchBarDelegate
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }

    func searchBarTextDidEndEditing(searchBar: UISearchBar){
        movies = allMovies
        tableView.reloadData()
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        hideSearchBar()
    }
    

    /* Helper methods */
    func searchTapped (sender: AnyObject) {
        showSearchBar()
    }
    
    func showSearchBar() {
        movieSearchBar.hidden = true
        //movieSearchBar.alpha = 0
        navigationItem.titleView = movieSearchBar
        navigationItem.setRightBarButtonItem(nil, animated: true)
        navigationItem.setLeftBarButtonItem(nil, animated: true)
        UIView.animateWithDuration(0.5, animations: {
            self.movieSearchBar.hidden = false
            //self.movieSearchBar.alpha = 1
            }, completion: { finished in
                self.movieSearchBar.becomeFirstResponder()
        })
    }
    
    func hideSearchBar() {
        navigationItem.setRightBarButtonItem(rightSearchBarButtonItem, animated: true)
        navigationItem.setLeftBarButtonItem(changeViewBarButton, animated: true)
        navigationItem.titleView = nil
        movieSearchBar.text = ""
    }
    /* -------------------------------------------------------------------------------------- */

    // MARKL - navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)
        let movie = movies![indexPath!.row]
        
        let detailViewController = segue.destinationViewController as! DetailViewController
        detailViewController.movie = movie
    }
    
   }


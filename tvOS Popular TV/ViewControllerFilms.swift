//
//  ViewController.swift
//  tvOS Popular TV
//
//  Created by durul dalkanat on 11/28/15.
//  Copyright © 2015 durul dalkanat. All rights reserved.
//

import UIKit

    struct LoadedMovies {
    static var cache: [String:Movie] = Dictionary<String, Movie>()
}

class ViewControllerFilms: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    //297, 420
    let defaultSize = CGSizeMake(297, 420)
    let focusSize = CGSizeMake(321, 455)
    
    let BASE_URL = "http://api.themoviedb.org/3/movie/popular?api_key=ff743742b3b6c89feb59dfc138b4c12f"
    
    var movies = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.layer.backgroundColor = UIColor.blackColor().CGColor
        downloadData()
    }
    func downloadData(){
        if let url = NSURL(string: BASE_URL) {
            let request = NSURLRequest(URL: url)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
                if error != nil {
                    print(error.debugDescription)
                } else {
                    do {
                        if let dta = data {
                            let dict = try NSJSONSerialization.JSONObjectWithData(dta, options: NSJSONReadingOptions.AllowFragments) as? Dictionary<String, AnyObject>
                            if let results = dict!["results"] as? [Dictionary<String, AnyObject>] {
                                //print(results)
                                for obj in results {
                                    let movie = Movie(movieDict: obj)
                                    self.movies.append(movie)
                                    LoadedMovies.cache[movie.title] = movie
                                }
                                //web request on background thread...get UI thread
                                dispatch_async(dispatch_get_main_queue()) {
                                    self.collectionView.reloadData()
                                }
                            }
                        }
                    } catch {
                        
                    }
                }
            }
            task.resume()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MovieCell", forIndexPath: indexPath) as? MovieCell {
            let movie = movies[indexPath.row]
            cell.configureCell(movie)
            if cell.gestureRecognizers?.count == nil {
                let tap = UITapGestureRecognizer(target: self, action: #selector(ViewControllerFilms.tapped(_:)))
                tap.allowedPressTypes = [NSNumber(integer: UIPressType.Select.rawValue)]  //enum
                cell.addGestureRecognizer(tap)
            }
            return cell
        } else {
            return MovieCell()
        }
    }
    func tapped(gesture: UITapGestureRecognizer) {
        if let cell = gesture.view as? MovieCell {
            //load the segue viewController and pass in the move
            //print("tap detected...\(cell.movieLbl.text)")
            if NSClassFromString("UIAlertController") != nil {
                let title = cell.movieLbl.text
                let alert = UIAlertController(title: title, message: cell.overview , preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    //MARK: UICollectionViewDelegateFlowlayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(333, 500)
    }
    override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        if let prev = context.previouslyFocusedView as? MovieCell {
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                prev.movieImg.frame.size = self.defaultSize
                prev.movieImg.layer.shadowColor = UIColor.blueColor().CGColor
                prev.movieImg.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
                prev.movieLbl.textColor = UIColor.whiteColor()
            })
        }
        if let next = context.nextFocusedView as? MovieCell {
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                next.movieImg.frame.size = self.focusSize
                next.movieImg.layer.shadowColor = UIColor.redColor().CGColor
                next.movieImg.layer.shadowOffset = CGSize(width: -5.0, height: -5.0)
                next.movieImg.layer.shadowOpacity = 0.5
                next.movieLbl.textColor = UIColor.redColor()
            })
        }
    }
}


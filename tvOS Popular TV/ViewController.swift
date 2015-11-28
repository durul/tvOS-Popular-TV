//
//  ViewController.swift
//  tvOS Popular TV
//
//  Created by durul dalkanat on 11/28/15.
//  Copyright © 2015 durul dalkanat. All rights reserved.
//

import UIKit

struct LoadedShows {
    static var cache: [String:Tv] = Dictionary<String, Tv>()
}

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    //Mark: Variable
    @IBOutlet weak var collectionTvView: UICollectionView!

    let defaultSize = CGSizeMake(297, 420)
    let focusSize = CGSizeMake(321, 455)
    
    let BASE_URL = "http://api.themoviedb.org/3/tv/popular?api_key=ff743742b3b6c89feb59dfc138b4c12f"
    
    var tvShows = [Tv]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionTvView.delegate = self
        collectionTvView.dataSource = self
        collectionTvView.layer.backgroundColor = UIColor.blackColor().CGColor
        retriveData()
    }
    
    func retriveData() {
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
                                    let tvshows = Tv(tvshowsDict: obj)
                                    self.tvShows.append(tvshows)
                                    LoadedShows.cache[tvshows.name] = tvshows
                                }
                                //web request on background thread...get UI thread
                                dispatch_async(dispatch_get_main_queue()) {
                                    self.collectionTvView.reloadData()
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
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("TvCell", forIndexPath: indexPath) as? TVCell {
            let movie = tvShows[indexPath.row]
            cell.configureCell(movie)
            if cell.gestureRecognizers?.count == nil {
                let tap = UITapGestureRecognizer(target: self, action: "tapped:")
                tap.allowedPressTypes = [NSNumber(integer: UIPressType.Select.rawValue)]  //enum
                cell.addGestureRecognizer(tap)
            }
            return cell
        } else {
            return TVCell()
        }
    }
    func tapped(gesture: UITapGestureRecognizer) {
        if let cell = gesture.view as? TVCell {
            //load the segue viewController and pass in the move
            //print("tap detected...\(cell.movieLbl.text)")
            if NSClassFromString("UIAlertController") != nil {
                let title = cell.tvLbl.text
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
        return tvShows.count
    }
    //MARK: UICollectionViewDelegateFlowlayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(333, 500)
    }
    override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        if let prev = context.previouslyFocusedView as? TVCell {
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                prev.tvImg.frame.size = self.defaultSize
                prev.tvImg.layer.shadowColor = UIColor.blueColor().CGColor
                prev.tvImg.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
                prev.tvLbl.textColor = UIColor.whiteColor()
            })
        }
        if let next = context.nextFocusedView as? TVCell {
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                next.tvImg.frame.size = self.focusSize
                next.tvImg.layer.shadowColor = UIColor.redColor().CGColor
                next.tvImg.layer.shadowOffset = CGSize(width: -5.0, height: -5.0)
                next.tvImg.layer.shadowOpacity = 0.5
                next.tvLbl.textColor = UIColor.redColor()
            })
        }
    }
}


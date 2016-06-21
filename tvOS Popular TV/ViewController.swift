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

    let defaultSize = CGSize(width: 297, height: 420)
    let focusSize = CGSize(width: 321, height: 455)
    
    let BASE_URL = "http://api.themoviedb.org/3/tv/popular?api_key=ff743742b3b6c89feb59dfc138b4c12f"
    
    var tvShows = [Tv]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionTvView.delegate = self
        collectionTvView.dataSource = self
        collectionTvView.layer.backgroundColor = UIColor.black().cgColor
        retriveData()
    }
    
    func retriveData() {
        if let url = URL(string: BASE_URL) {
            let request = URLRequest(url: url)
            let session = URLSession.shared()
            let task = session.dataTask(with: request) { (data, response, error) -> Void in
                if error != nil {
                    print(error.debugDescription)
                } else {
                    do {
                        if let mydata = data {
                            let dict = try JSONSerialization.jsonObject(with: mydata, options: JSONSerialization.ReadingOptions.allowFragments) as? Dictionary<String, AnyObject>
                            if let results = dict!["results"] as? [Dictionary<String, AnyObject>] {
                                //print(results)
                                for obj in results {
                                    let tvshows = Tv(tvshowsDict: obj)
                                    self.tvShows.append(tvshows)
                                    LoadedShows.cache[tvshows.name] = tvshows
                                }
                                //web request on background thread...get UI thread
                                DispatchQueue.main.async {
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
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TvCell", for: indexPath) as? TVCell {
            let tvshows = tvShows[(indexPath as NSIndexPath).row]
            cell.configureCell(tvshows)
            
            if cell.gestureRecognizers?.count == nil {
                let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapped(_:)))
                tap.allowedPressTypes = [NSNumber(value: UIPressType.select.rawValue)]  //enum
                cell.addGestureRecognizer(tap)
            }
            return cell
        } else {
            return TVCell()
        }
    }
    
    func tapped(_ gesture: UITapGestureRecognizer) {
        if let cell = gesture.view as? TVCell {
            //load the segue viewController and pass in the move

            if NSClassFromString("UIAlertController") != nil {
                let title = cell.tvLbl.text
                let alert = UIAlertController(title: title, message: cell.overview , preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tvShows.count
    }
    
    //MARK: UICollectionViewDelegateFlowlayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 333, height: 500)
    }
    
    // tvOS Popular tv shows Image Focus

    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if let prev = context.previouslyFocusedView as? TVCell {
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                prev.tvImg.frame.size = self.defaultSize
                prev.tvImg.layer.shadowColor = UIColor.blue().cgColor
                prev.tvImg.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
                prev.tvLbl.textColor = UIColor.white()
            })
        }
        if let next = context.nextFocusedView as? TVCell {
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                next.tvImg.frame.size = self.focusSize
                next.tvImg.layer.shadowColor = UIColor.red().cgColor
                next.tvImg.layer.shadowOffset = CGSize(width: -5.0, height: -5.0)
                next.tvImg.layer.shadowOpacity = 0.5
                next.tvLbl.textColor = UIColor.red()
            })
        }
    }
}


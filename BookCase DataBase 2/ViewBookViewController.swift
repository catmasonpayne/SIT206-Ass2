//
//  ViewBookViewController.swift
//  BookCase DataBase 2
//
//  Created by Cat Mason-Payne on 21/05/2017.
//  Copyright © 2017 Deakin. All rights reserved.
//

import UIKit

class SimilarBookCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var titleLabelCell: UILabel!
    @IBOutlet weak var authorLabelCell: UILabel!
    
}


class ViewBookViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    // empty database array
    var DBArr = [[String]]()
    // array for similar books to fill the collection view
    var similarBooks = [[String]]()
    // variables to fill in!
    @IBOutlet weak var bookName: UILabel!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var summaryScrollView: UIScrollView!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var isbnLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var seriesLabel: UILabel!
    @IBOutlet weak var movieLabel: UILabel!
    @IBOutlet weak var seriesLine: UILabel!
    @IBOutlet weak var movieLine: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // these were passed through the segue
    var bookNameFromPrev = String()
    var bookAuthorFromPrev = String()
    var genreString = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dataimport = GetDatabaseData()
        
        DBArr = dataimport.importDatabase()
        
        for i in 0...(DBArr.count - 1) {
            if bookNameFromPrev == DBArr[i][0] && bookAuthorFromPrev == DBArr[i][1] {
                // set up data
                bookName.text = bookNameFromPrev
                authorName.text = bookAuthorFromPrev
                bookImage.image = UIImage(named: DBArr[i][3])
                summaryLabel.text = DBArr[i][9]
                genreLabel.text = DBArr[i][2]
                genreString = DBArr[i][2]
                ratingLabel.text = "Rating: \(DBArr[i][7])"
                isbnLabel.text = "ISBN: \(DBArr[i][4])"
                publisherLabel.text = "Publisher: \(DBArr[i][6])"
                if DBArr[i][8].lowercased() == "n/a" {
                    seriesLabel.isHidden = true
                    seriesLine.isHidden = true
                } else {
                    seriesLabel.text = "\(DBArr[i][8]) in series"
                }
                if DBArr[i][5].lowercased() == "n/a" {
                    movieLabel.isHidden = true
                    movieLine.isHidden = true
                } else {
                    movieLabel.text = "Movie Release: \(DBArr[i][5])"
                }
                
            }
            
        }
        createSimilarBookArray()
        print(createSimilarBookArray())
        print("just printed the array yo")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // set up similar books array in prep for collection view
    func createSimilarBookArray() {
        for i in 0...(DBArr.count - 1) {
            if DBArr[i][2].lowercased().range(of: genreString.lowercased()) != nil || genreString.lowercased().range(of: DBArr[i][2].lowercased()) != nil {
                // if a genre type matches
                var tempArr = [String]()
                for index in 0...9 {
                    tempArr.append(DBArr[i][index])
                }
                similarBooks.append(tempArr)
            }
        }
        
    }
    
    // collectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return similarBooks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SimilarCell2", for: indexPath as IndexPath) as! SimilarBookCollectionViewCell
        
        cell.bookImageView.image = UIImage(named: similarBooks[indexPath.item][3])
        cell.titleLabelCell.text = similarBooks[indexPath.item][0]
        cell.authorLabelCell.text = similarBooks[indexPath.item][1]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("you have selected from left2")
        print(indexPath.item)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AnotherBookRight" {
            print("preping for segue right2")
            let displayBookVC = segue.destination as? DisplayBookViewController
            
            guard let cell = sender as? UICollectionViewCell, let indexPath = collectionView.indexPath(for: cell) else {
                return
            }
            displayBookVC?.bookNameFromPrev = similarBooks[indexPath.item][0]
            displayBookVC?.bookAuthorFromPrev = similarBooks[indexPath.item][1]
        }
    }
    
    
    // tidying up
    override var prefersStatusBarHidden: Bool {
        return true;
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let value =  UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()
    }

}

//
//  MemeTableViewController.swift
//  MemeMe 2.0
//
//  Created by Francis Wairegi on 2/2/19.
//  Copyright © 2019 Francis Wairegi. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {
    
    //MARK: Properties
//    var memes: [Meme]! {
//        let object = UIApplication.shared.delegate
//        let appDelegate = object as! AppDelegate
//        return appDelegate.memes
//    }
    var memes = [Meme] ()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        memes = appDelegate.memes
        
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "MemeTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MemeTableViewCell else {
            fatalError("The dequeued cell is not an instance of MemeMeTableViewCell")
        }
        
        // Fetches the appropriate meme for the data source layout.
        // Concatenates the top and bottom texts to form the label
        let meme = memes[indexPath.row]
        cell.memeImageView.image = meme.memedImage
        cell.memeLabel.text = meme.topText + " " + meme.bottomText
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Grab the MemeDetailViewController from Storyboard
        let memeDetailViewController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        
        //Populate view controller with data from the selected item
        memeDetailViewController.meme = memes[indexPath.row]
        
        // Present the view controller using navigation
        navigationController!.pushViewController(memeDetailViewController, animated: true)
    }
    
    // Delete a meme from the Table View
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            memes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
 }

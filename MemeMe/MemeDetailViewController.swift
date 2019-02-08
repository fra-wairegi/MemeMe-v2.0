//
//  MemeDetailViewController.swift
//  MemeMe 2.0
//
//  Created by Francis Wairegi on 2/4/19.
//  Copyright © 2019 Francis Wairegi. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    //MARK: Properties
    @IBOutlet weak var memeDetailImage: UIImageView!
    var meme: Meme!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        memeDetailImage.image = meme.memedImage;
    }
}

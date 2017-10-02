//
//  PreviewViewController.swift
//  Propho
//
//  Created by Sofie Kedvik on 2017-09-29.
//  Copyright © 2017 Sofie Kedvik. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Preview"

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

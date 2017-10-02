//
//  ScoreViewController.swift
//  Propho
//
//  Created by Sofie Kedvik on 2017-09-28.
//  Copyright © 2017 Sofie Kedvik. All rights reserved.
//

import UIKit

class ScoreViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scoreSegment: UISegmentedControl!
    
    var complete: ((Rating?) -> ())!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(ScoreViewController.save))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(ScoreViewController.cancel))
        
        title = "Add and Rate"
    }
    
    // @objc stands for objective c - first version of swift before it was named swift
    
    @objc func save() {
        
        let rating = Rating(text: titleTextField.text!, score: scoreSegment.selectedSegmentIndex + 1, photo: imageView.image!, date: Date())
        
        complete(rating)
        
    }
    
    @objc func cancel() {
        complete(nil)
    }
    
    
    // when you touch outside the textfield it will hide/remove the keyboard functionality
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        if !titleTextField.frame.contains(touch.location(in: view)) {
            view.endEditing(true)
        }
    }
}

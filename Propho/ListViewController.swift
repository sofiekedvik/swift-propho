//
//  ListViewController.swift
//  Propho
//
//  Created by Sofie Kedvik on 2017-09-27.
//  Copyright © 2017 Sofie Kedvik. All rights reserved.
//

import UIKit

extension UIImage {
    func resized(to targetSize: CGSize) -> UIImage {
        let size = self.size
        
        let widthRatio  = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        
        var newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}

extension ListViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        let scoreVC = storyboard!.instantiateViewController(withIdentifier: "score") as! ScoreViewController
        
        _ = scoreVC.view
        
        scoreVC.imageView.image = image
        
        // if someone pushed save call closure
        scoreVC.complete = { rating in
            if let rating = rating {
                Database.insert(rating: rating)
            }
            picker.dismiss(animated: true, completion: nil)
            
        }
        
        picker.isNavigationBarHidden = false
        picker.pushViewController(scoreVC, animated: true)
            
//        Database.insert(rating: Rating(text: "myphoto", score: 3, photo: image.resized(to: CGSize(width: 375, height: 667))))
//        picker.dismiss(animated: true)
    }
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}


class ListViewController: UITableViewController {
    
    @IBAction func addButton(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self

        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
            // User choosed camera
            picker.sourceType = .camera
            self.present(picker, animated: true, completion: nil)
            
        }
        
        let libraryAction = UIAlertAction(title: "Library", style: .default) { _ in
            // User choosed library
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true, completion: nil)
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            // User choosed cancel
            
        }
        
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(libraryAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    var ratings = [Rating]() {
        didSet { tableView.reloadData() }
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        title = "Your Images"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ratings = Database.allRatings
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ratings.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! PhotoTableViewCell

        // Configure the cell...
        
        let rating = ratings[indexPath.row]
        var stars = ""
        for _ in 0..<rating.score  {
           stars += "❤️"
        }
        
        if rating.score < 5 {
            let stardark = 5 - rating.score
            for _ in 0..<stardark  {
                stars += "💛"
            }
        }
        
        
        cell.photoTitleLabel.text = stars
        cell.photoImageView.image = rating.photo
        
        let overlay: UIView = UIView(frame: CGRect(x: 0, y: 0, width: cell.photoImageView.frame.size.width, height: 200))
        overlay.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.1)
        cell.photoImageView.addSubview(overlay)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let previewVC = storyboard!.instantiateViewController(withIdentifier: "preview") as! PreviewViewController
        
        let image = ratings[indexPath.row].photo
        let score = ratings[indexPath.row].score
        let text = ratings[indexPath.row].text
        let date = ratings[indexPath.row].date
        let formater = DateFormatter()
        formater.dateFormat = "yyyy-MM-dd"
        let dateString = formater.string(from: date)
        
        var hearts = ""
        for _ in 0..<score {
            hearts += "❤️"
        }
        
        if score < 5 {
            let stardark = 5 - score
            for _ in 0..<stardark  {
                hearts += "💛"
            }
        }
        
        _ = previewVC.view
        
        previewVC.imageView.image = image
        previewVC.rateLabel.text = hearts
        previewVC.titleLabel.text = text
        previewVC.dateLabel.text = dateString
        
        navigationController?.pushViewController(previewVC, animated: true)
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            // let rating = ratings[indexPath.row]!
            
            // Delete rating in Database
            Database.delete(rating: indexPath.row)
            
            // Update our list in Database
            ratings = Database.allRatings
        }
    }
 

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

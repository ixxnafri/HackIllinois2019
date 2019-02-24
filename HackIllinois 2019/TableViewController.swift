//
//  TableViewController.swift
//  HackIllinois 2019
//
//  Created by Pamela Sanan on 2/23/19.
//  Copyright © 2019 Pamela Sanan. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var rooms = ["Room 1", "Room 2", "Room 3"]
    
    var yourVariable : UIViewController!
    
    var yourVariable2 : UIViewController!

    var yourVariable3 : UIViewController!


    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "LabelCell")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return rooms.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)

        cell.textLabel?.text = rooms[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let indexPath = tableView.indexPathForSelectedRow
//
//        let currentCell = tableView.cellForRow(at: indexPath!)
//
//        let currentItem = currentCell!.textLabel!.text
//
//        let alertController = UIAlertController(title: "Simplified iOS", message: "You selected " + currentItem! , preferredStyle: .alert)
//
//        let defaultAction = UIAlertAction(title: "Close Alert", style: .default, handler: nil)
//
//        alertController.addAction(defaultAction)
//
//        present(alertController, animated: true, completion: nil)
        
        
//        let destination = ViewController() // Your destination
//        navigationController?.pushViewController(destination, animated: true)
//        self.performSegue(withIdentifier: "segue1", sender: self)
        
        let indexPath = tableView.indexPathForSelectedRow
        let currentCell = tableView.cellForRow(at: indexPath!)
        let currentItem = currentCell!.textLabel!.text
        
        if (currentItem == "Room 1"){
//            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//            let destination = storyboard.instantiateViewController(withIdentifier: "data") as! ViewController
//            navigationController?.pushViewController(destination, animated: true)
            if yourVariable == nil {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                yourVariable = storyboard.instantiateViewController(withIdentifier: "data")
            }
            navigationController?.pushViewController(yourVariable, animated: true)
        }
        else if (currentItem == "Room 2"){
            if yourVariable2 == nil {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                yourVariable2 = storyboard.instantiateViewController(withIdentifier: "data2")
            }
            navigationController?.pushViewController(yourVariable2, animated: true)
        }
        else{
            if yourVariable3 == nil {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                yourVariable3 = storyboard.instantiateViewController(withIdentifier: "data3")
            }
            navigationController?.pushViewController(yourVariable3, animated: true)
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

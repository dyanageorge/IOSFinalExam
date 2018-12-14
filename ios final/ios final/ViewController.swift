//
//  ViewController.swift
//  ios final
//
//  Created by Dyana George on 12/13/18.
//  Copyright © 2018 Dyana George. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    
    var bmiName: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //reload from core data
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName:"BMICount")
        
        //error code
        do {
            bmiName = try context.fetch(fetchRequest)
        } catch  {
            print("Errpr in loading data")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var titleTextField: UITextField!
    
    //make place holder
    func titleTextField(textfield: UITextField) {
        titleTextField = textfield
        titleTextField.placeholder  = "BMI Calculation"
    }

    //when add button is pressed have alert popup that stores the data
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "BMI info", message: "Add Your Personal Infomation Below", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Save", style: .default, handler: self.save)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        alert.addTextField(configurationHandler: titleTextField)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //delete option
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            context.delete(bmiName[indexPath.row])
            bmiName.remove(at: indexPath.row)
            
            //error message for delete option
            do{
                try context.save()
            } catch {
                print("There was an error while tryig to delete")
            }
            self.tableView.reloadData()
        }
    }
    
    //save the app to core data
    func save(alert: UIAlertAction!) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "BMICount", in: context)!
        let theTitle = NSManagedObject(entity: entity, insertInto: context)
        theTitle.setValue(titleTextField.text, forKey: "title")
        
        //error message for saving data
        do {
            try context.save()
            bmiName.append(theTitle)
        } catch {
            print("There wa an error in saving")
        }
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bmiName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let title = bmiName[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = title.value(forKey: "title") as? String
        return cell
        
    }


}


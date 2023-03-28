//
//  ViewController.swift
//  TravelBook
//
//  Created by Abraham Cervantes on 4/20/22.
//

import UIKit
import CoreData
import MapKit
class ViewController: UIViewController, NSFetchedResultsControllerDelegate,UITableViewDataSource,UITableViewDelegate{

    @IBOutlet weak var locationTable: UITableView!
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private let persistentContainer = NSPersistentContainer(name:"TravelBook")
    
    @IBOutlet weak var tableMessage: UILabel!
    
    var count = 0;
    var model:LocationModel?
    
    var  fetchResults =   [LocationEntity]()
    
    func fetchRecord() -> Int {
        // Create a new fetch request using the FruitEntity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LocationEntity")
        let sort = NSSortDescriptor(key: "country", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        var x   = 0
        // Execute the fetch request, and cast the results to an array of FruitEnity objects
        fetchResults = ((try? managedObjectContext.fetch(fetchRequest)) as? [LocationEntity])!
        
        
        x = fetchResults.count
        
        print(x)
        
        // return howmany entities in the coreData
        return x
        
        
    }
    
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<LocationEntity> = {
        let fetchRequest:NSFetchRequest<LocationEntity> = LocationEntity.fetchRequest()
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "country", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationTable.delegate = self
        locationTable.dataSource = self
        
        persistentContainer.loadPersistentStores{(persistentContainer, error) in
            if let error = error {
                print("Unable to load")
                print(error.localizedDescription)
            }else{
                //self.setupView()
                
                do{
                    try self.fetchedResultsController.performFetch()
                }catch{
                    let fetchEr = error as NSError
                    print(fetchEr.localizedDescription)
                }
                //self.updateView()
            }
            
        }
    }

    
    @IBAction func addLocation(_ sender: Any) {
        
        let alert = UIAlertController(title: "Add Location", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Enter Name of the Location Here"
        })
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Enter Country"
        })
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            
            // Do this first, then use method 1 or method 2
            if let name = alert.textFields?.first?.text {
                print("city name: \(name)")
                var country = alert.textFields?[1].text
                
                
                //Method 1
                if let location = self.fetchedResultsController.fetchedObjects{
                    let ent = NSEntityDescription.entity(forEntityName: "LocationEntity", in: self.persistentContainer.viewContext)
                    let newLocation = LocationEntity(entity: ent!, insertInto: self.persistentContainer.viewContext)
                    newLocation.name = name
                    newLocation.country = country
                    
                    do{try self.persistentContainer.viewContext.save()}
                    catch _{}
                    let indexPath = IndexPath (row: location.count , section: 0)
                    //self.locationTable.beginUpdates()
                    //self.locationTable.insertRows(at: [indexPath], with: .automatic)
                    //self.locationTable.endUpdates()
                    self.locationTable.reloadData()
                    
                    DispatchQueue.main.async {
                        self.locationTable.reloadData()
                    }
                }
                
               //Method 2
                self.locationTable.reloadData()
            }
        }))
        
        self.present(alert, animated: true)
        reloadTable()
        self.locationTable.reloadData()
        
    }
    
    @IBAction func removeLocation(_ sender: Any) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LocationEntity")
        
        // whole fetchRequest object is removed from the managed object context
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try managedObjectContext.execute(deleteRequest)
            try managedObjectContext.save()
            
            
        }
        catch let _ as NSError {
            // Handle error
        }
        
        locationTable.reloadData()
    }
    
    
    func reloadTable()
    {
        locationTable.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // number of rows based on the coredata storage
        return fetchRecord()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // add each row from coredata fetch results
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as? LocationCell else{
            fatalError("Unexpected")
        }

        //cell.layer.borderWidth = 1.0
        cell.locLabel?.text = fetchResults[indexPath.row].name
        cell.countryLabel?.text = fetchResults[indexPath.row].country
        
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let selectedIndex: IndexPath = self.locationTable.indexPath(for: sender as! UITableViewCell)!
        var poop = fetchRecord()
        
        let city = fetchResults[selectedIndex.row].name
        
        
        
        if(segue.identifier == "detailView"){
            if let viewController: DetailViewController = segue.destination as? DetailViewController {
                viewController.selectedCity = city;
                viewController.managedObjectContext = managedObjectContext
            }
        }
    }
    
    
    
    
}

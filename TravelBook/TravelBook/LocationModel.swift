//
//  LocationModel.swift
//  TravelBook
//
//  Created by Abraham Cervantes on 4/20/22.
//

import Foundation
import CoreData
public class LocationModel{
    let managedObjectContext:NSManagedObjectContext?
    
    var fetchResults = [LocationEntity]()
    var counter = 1
    
    init(context: NSManagedObjectContext)
    {
        managedObjectContext = context
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LocationEntity")
        let sort = NSSortDescriptor(key: "country", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        fetchResults = ((try? managedObjectContext!.fetch(fetchRequest)) as? [LocationEntity])!
    }
    
    func fetchRecord() -> Int {
        // Create a new fetch request using the FruitEntity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LocationEntity")
        let sort = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        var x   = 0
        // Execute the fetch request, and cast the results to an array of FruitEnity objects
        fetchResults = ((try? managedObjectContext!.fetch(fetchRequest)) as? [LocationEntity])!
        
        
        x = fetchResults.count
        
        print(x)
        
        // return howmany entities in the coreData
        return x
    }
    
    func findRecord(name: String)->NSManagedObject?
    {
        var match:NSManagedObject?
        
        let entityDesc = NSEntityDescription.entity(forEntityName:"LocationEntity",in: managedObjectContext!)
        
        let request: NSFetchRequest<LocationEntity> = LocationEntity.fetchRequest() as! NSFetchRequest<LocationEntity>
        
        request.entity = entityDesc
        
        let pred = NSPredicate(format: "(name = %@",name)
        request.predicate = pred
        
        do{
            var results =
                try managedObjectContext!.fetch(request as!
                    NSFetchRequest<NSFetchRequestResult>)
            
            if results.count > 0 {
                 match = results[0] as! NSManagedObject
                 //return match
            } else {
                //return match
            }
        }catch let error{
            print(error.localizedDescription)
        }
        
        return match
    }
    
    func SaveContext(name:String,country:String,dEntry:String,lat:Double,long:Double)
    {
        let ent = NSEntityDescription.entity(forEntityName:"LocationEntity", in: self.managedObjectContext!)
        let location = LocationEntity(entity:ent!,insertInto: managedObjectContext)
        location.name = name
        location.country = country
        location.dEntry = dEntry
        location.lat = lat
        location.long = long
        
        do{
            try managedObjectContext!.save()
            print("location Saved")
        }catch let error{
            print(error.localizedDescription)
        }
    }
    
    func deleteRecord(search:String)
    {
        let fetchRequest: NSFetchRequest<LocationEntity> = LocationEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format:"name = %@",search)
        
        if let result = try? managedObjectContext?.fetch(fetchRequest){
            for object in result{
                managedObjectContext!.delete(object)
            }
        }
        do{
            try managedObjectContext!.save()
        }catch let error{
            print(error.localizedDescription)
        }
    }
    
    func getCount()->Int{
        let fetchRequest = NSFetchRequest<LocationEntity>(entityName: "LocationEntity")
        do{
            let count = try managedObjectContext!.count(for: fetchRequest)
            return count
            
        }catch let error{
            print(error.localizedDescription)
        }
        return 0
    }
    
    
    
}

//
//  MapAndAPI.swift
//  TravelBook
//
//  Created by Abraham Cervantes on 4/23/22.
//

import Foundation
import MapKit
class MapAndAPI
{
    var latLabel:String?
    var longLabel:String?
    var sendCoords:CLLocation?
    let annotation = MKPointAnnotation()
    func getCoords(location:String,completionHandler:@escaping ()->())
    {
        //var geoCoder = CLGeocoder();
        CLGeocoder().geocodeAddressString(location, completionHandler:  { (placemarks,error) in
            
            let placemark = placemarks?.first
            self.sendCoords = placemark?.location
            completionHandler()
        })
        
        
        //return sendCoords!
        
        
    }
    func getCLL()->CLLocation
    {
        return sendCoords!
    }
    
    func processResponse(withPlacemarks placemarks: [CLPlacemark]?,error:Error?)
    {
        if let error = error{
            print("Unable to Forward Geocode")
        }else{
            var location:CLLocation?
            if let placemarks = placemarks, placemarks.count > 0{
                location = placemarks.first?.location
            }
            if let location = location {
                sendCoords = location
                let coordinate = location.coordinate
                latLabel = "\(coordinate.latitude)"
                longLabel = "\(coordinate.longitude)"
                //addPin(coord: location.coordinate)
                
            }else{
                latLabel = "Not Found"
                longLabel = "Not Found"
            }
        }
        
        
    }
    
    
    
    
}

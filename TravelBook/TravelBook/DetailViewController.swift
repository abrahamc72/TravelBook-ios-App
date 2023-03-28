//
//  DetailViewController.swift
//  TravelBook
//
//  Created by Abraham Cervantes on 4/23/22.
//

import Foundation
import UIKit
import MapKit
import CoreData
class DetailViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate
{
    var selectedCity:String?
    var managedObjectContext: NSManagedObjectContext?
    
    
    @IBOutlet weak var distancelabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var detailIMG: UIImageView!
    @IBOutlet weak var googleIMG: UIImageView!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var latLabel: UILabel!
    @IBOutlet weak var longLabel: UILabel!
    
    var pic: NSData?
    let annotation = MKPointAnnotation()
    
    var count = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var dub = Int.random(in:25..<1999)
        distancelabel.text = "\(dub) "
        cityLabel.text = selectedCity
        loadMap()
        getGoogleImage()
    }
    func getGoogleImage()
    {
        var removespace = selectedCity?.replacingOccurrences(of: " ", with: "_")
        
        let urlAsString = "https://serpapi.com/search.json?engine=google&q=" + removespace! + "&google_domain=google.com&tbm=isch&num=1&ijn=0&device=mobile&api_key=11ea8f5f1cb533332332529bb00c164b9f093122a8c484bbe388d8a523491e8a"
        
        let url = URL(string: urlAsString)!
        
        let urlSession = URLSession.shared
        
        
        let jsonQuery = urlSession.dataTask(with: url, completionHandler: { data, response, error -> Void in
            if (error != nil) {
                print(error!.localizedDescription)
            }
            var err: NSError?
            
            
            var jsonResult = (try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
            if (err != nil) {
                print("JSON Error \(err!.localizedDescription)")
            }
            
            print(jsonResult)
          
           let setOne:NSArray = jsonResult["images_results"] as! NSArray
            //print(setOne);
            
            for i in 0...1
            {
                let y = setOne[i] as? [String: AnyObject]
                //print(y?["lng"])
                
                var urlStr: String = ((y!["thumbnail"] as! NSString) as String)
                var realURL = URL(string: urlStr)
                print("HEREHERHERHEHREHRHEHREHRHEHREHRHERHEHRHERH")
                print(urlStr)
                self.googleIMG.load(url: realURL!)
                 //print(lt)
            }
            DispatchQueue.main.async
                {
                    //self.updateBox()
            }
            
          
        })
        
        jsonQuery.resume()
        //updateBox()
    }
    
    
    @IBAction func uploadPhoto(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Add Photo", message: "", preferredStyle: .alert)
        
        let serachAction = UIAlertAction(title: "Camera Roll", style: .default) { (aciton) in
            let photoPicker = UIImagePickerController ()
            photoPicker.delegate = self
            photoPicker.sourceType = .photoLibrary
            // display image selection view
            self.present(photoPicker, animated: true, completion: nil)
            
            self.present(alertController, animated: true, completion: nil)
            
        }
        let cancelAction = UIAlertAction(title: "Take Photo", style: .cancel) {
            (action) in
            
            // load image
            let photoPicker = UIImagePickerController ()
            photoPicker.delegate = self
            photoPicker.sourceType = .camera
            // display image selection view
            self.present(photoPicker, animated: true, completion: nil)
            
            self.present(alertController, animated: true, completion: nil)
                
            
        }
        
        alertController.addAction(serachAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        
        picker .dismiss(animated: true, completion: nil)

        // fetch resultset has the recently added row without the image
        // this code ad the image to the row
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.pic = image.pngData()! as NSData
            //update the row with image
            detailIMG!.image = UIImage(data: self.pic as! Data)
            //updateLastRow()
            do {
                try print("Hello")
            } catch {
                print("Error while saving the new image")
            }
            
        }
        
    }
    
    
    
    func loadMap()
    {
        var geoCoder = CLGeocoder();
        geoCoder.geocodeAddressString(selectedCity!){placemarks,error in
            self.processResponse(withPlacemarks: placemarks, error:error)
            
        }
        
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
                let coordinate = location.coordinate
                latLabel.text = "\(coordinate.latitude)"
                longLabel.text = "\(coordinate.longitude)"
                addPin(coord: location.coordinate)
                
            }else{
                latLabel.text = "Not Found"
                longLabel.text = "Not Found"
            }
        }
        
        
    }
    
    func addPin(coord: CLLocationCoordinate2D) {
        mapView.removeAnnotation(annotation)
        let centerCoordinate = CLLocationCoordinate2D(latitude: coord.latitude, longitude:coord.longitude)
        annotation.coordinate = centerCoordinate
        annotation.title = selectedCity
        mapView.addAnnotation(annotation)
        //detailMapView.camera.altitude *= 0.35;
        mapView.showAnnotations([annotation], animated: false)
        mapView.camera.altitude *= 1.5;
        
    }
}
extension UIImageView{
    
    func load(url:URL)
    {
        DispatchQueue.global().async{
            if let data = try? Data(contentsOf: url){
                if let image = UIImage(data: data)
                {
                    DispatchQueue.main.async {
                        self.image = image
                    }
                }
            }
        }
    }
}

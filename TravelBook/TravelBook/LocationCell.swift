//
//  LocationCell.swift
//  TravelBook
//
//  Created by Abraham Cervantes on 4/23/22.
//

import Foundation
import UIKit
class LocationCell: UITableViewCell{
    
    @IBOutlet weak var countryLabel: UILabel!
    
    @IBOutlet weak var locLabel: UILabel!
    
    //@IBOutlet weak var countryLabel: UILabel!
    
    static let reuseIdentifier = "LocationCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//
//  manageInventoryTableViewCell.swift
//  InterviewAtBnSellit
//
//  Created by Dheeraj's MacBook Pro on 2022-01-14.
//

import UIKit

class manageInventoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var customContentView: UIView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        customUI()
        
    }
    
    func customUI(){
        customContentView.layer.cornerRadius = 10
        editButton.layer.cornerRadius = 6
        deleteButton.layer.cornerRadius = 6

    }
    @IBAction func editButtonClicked(_ sender: Any) {
        
    }
    
    @IBAction func deleteButtonClicked(_ sender: Any) {
    }
    
}

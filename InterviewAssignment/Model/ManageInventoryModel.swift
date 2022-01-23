//
//  ManageInventoryModel.swift
//  InterviewAtBnSellit
//
//  Created by Dheeraj's MacBook Pro on 2022-01-14.
//

import UIKit

struct InventoryModel {
    let id, qty: Int
    let price: Double
    let squ, title, description, image: String
    
    init(id: Int, qty: Int, price: Double, squ: String, title: String, description: String, image: String) {
        self.id = id
        self.qty = qty
        self.price = price
        self.squ = squ
        self.title = title
        self.description = description
        self.image = image
    }

}

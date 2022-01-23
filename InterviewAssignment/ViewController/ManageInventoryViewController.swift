//
//  ManageInventoryViewController.swift
//  InterviewAtBnSellit
//
//  Created by Dheeraj's MacBook Pro on 2022-01-14.
//

import UIKit

class ManageInventoryViewController: UIViewController  {
    
    @IBOutlet weak var addNewInventoryBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var inventoryArray : [InventoryModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        addNewInventoryBtn.layer.cornerRadius = 8
        getInventoriesWSCAll(url: Constants.getInventoryUrl)
    }
    
    @IBAction func addNewInventoryBtnClicked(_ sender: Any) {
    }
    
    func getInventoriesWSCAll(url: String){
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        request.url = URL(string: url)
        
        let task1 = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
            
            if(data != nil && data?.count != 0)
            {
                self.parseJson(data: data!)
            }
        })
        task1.resume()
    }
    
    func parseJson(data: Data){
        if let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [Any] {
            for item in json {
                if let object = item as? [String: Any] {
                    
                    let id = object["id"] as? Int ?? 999
                    let price = object["price"] as? Double ?? 0.00
                    let qty = object["qty"] as? Int ?? 999
                    let squ = object["squ"] as? String ?? "N/A"
                    let title = object["title"] as? String ?? "N/A"
                    let description = object["description"] as? String ?? "N/A"
                    let image = object["image"] as? String ?? "N/A"
                    
                    inventoryArray.append(InventoryModel.init(id: id, qty: qty, price: price, squ: squ, title: title, description: description, image: image))
                }
            }
            print("Array:: \(inventoryArray)")
            DispatchQueue.main.async { [self] in
                tableView.reloadData()
            }
        }
    }
}

extension ManageInventoryViewController: UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:manageInventoryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! manageInventoryTableViewCell
        cell.titleLabel.text = inventoryArray[indexPath.row].title
        cell.priceLabel.text = "$" + String(inventoryArray[indexPath.row].price) + " CAD"
        cell.productImageView.imageFromUrl(urlString: inventoryArray[indexPath.row].image)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inventoryArray.count
    }
}

extension ManageInventoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddInventoryViewController") as? AddInventoryViewController
        vc?.productImage = inventoryArray[indexPath.row].image
        vc?.inventoryTitle = inventoryArray[indexPath.row].title
        vc?.desc = inventoryArray[indexPath.row].description
        vc?.price = String(inventoryArray[indexPath.row].price)
        vc?.qty = String(inventoryArray[indexPath.row].qty)
        vc?.isSelected = true
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}

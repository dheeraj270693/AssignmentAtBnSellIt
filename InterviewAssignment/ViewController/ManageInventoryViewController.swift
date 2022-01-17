//
//  ManageInventoryViewController.swift
//  InterviewAtBnSellit
//
//  Created by Dheeraj's MacBook Pro on 2022-01-14.
//

import UIKit
import Kingfisher

class ManageInventoryViewController: UIViewController  {
    
    @IBOutlet weak var addNewInventoryBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var inventoryArray : [InventoryModel] = []
    
    struct InventoryModel {
        let id, qty: Int
        let price: Double
        let squ, title, description, image: String
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        addNewInventoryBtn.layer.cornerRadius = 8
        getInventoriesWSCAll(url: Constants.getInventoryUrl)
    }
    
    @IBAction func addNewInventoryBtnClicked(_ sender: Any) {
        //        let conn = ConnectionHelper()
        //        conn.getInventoryData()
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
                    
                    print("Object::: \(object)")
                    
                    let id = object["id"] as? Int ?? 999
                    let price = object["price"] as? Double ?? 0.00
                    let qty = object["qty"] as? Int ?? 999
                    let squ = object["squ"] as? String ?? "N/A"
                    let title = object["title"] as? String ?? "N/A"
                    let description = object["description"] as? String ?? "N/A"
                    let image = object["image"] as? String ?? "N/A"
                    
                    // Save data using your Model
                    inventoryArray.append(InventoryModel.init(id: id, qty: qty, price: price, squ: squ, title: title, description: description, image: image))
                }
            } // end of For loop
            print("Array:: \(inventoryArray)")
            // Reload data of TableView/CollectionView
            DispatchQueue.main.async { [self] in
                tableView.reloadData()
            }
        }
    }
    
    /*
     // MARK: - Navigation
     #imageLiteral(resourceName: "simulator_screenshot_59AF1610-0391-41D3-9CD6-5A19941014CD.png")
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension ManageInventoryViewController: UITableViewDataSource  {
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create a new cell if needed or reuse an old one
        let cell:manageInventoryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! manageInventoryTableViewCell
        cell.titleLabel.text = inventoryArray[indexPath.row].title
        cell.priceLabel.text = String(inventoryArray[indexPath.row].price)
        cell.productImageView.image = UIImage(named: inventoryArray[indexPath.row].image) ?? UIImage(named: "productImage")
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inventoryArray.count
    }
    
}

extension ManageInventoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        print("Clicked")
        print(inventoryArray[indexPath.row])
        
        //        let category = inventoryArray[indexPath.row]
        //        let addVC = AddInventoryViewController()
        //        addVC.categoryTextLabel = inventoryArray[indexPath.row].
        //        addVC.inventoryTitleTextField.text = category.title
        //        addVC.descriptionTextView.text = category.description
        //        addVC.priceTextField.text = String(category.price)
        //        addVC.quantityTextField.text = String(category.qty)
        
        //        navigationController?.pushViewController(addVC, animated: true)
    }
}

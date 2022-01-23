//
//  AddInventoryViewController.swift
//  InterviewAtBnSellit
//
//  Created by Dheeraj's MacBook Pro on 2022-01-14.
//

import UIKit
import DropDown

class AddInventoryViewController: UIViewController {
    
    @IBOutlet weak var curvedView: UIView!
    @IBOutlet weak var prodImageView: UIImageView!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var categoryTextLabel: UILabel!
    @IBOutlet weak var inventoryTitleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var addForSaleButton: UIButton!
    @IBOutlet weak var addForRentButton: UIButton!
    @IBOutlet weak var addNewInventoryButton: UIButton!
    
    let dropDown = DropDown()
    var flagSale:Bool = false
    var flagRent:Bool = false
    var categoryArray : [String] = []
    
    var productImage = ""
    var inventoryTitle = ""
    var desc = ""
    var price = ""
    var qty = ""
    var isSelected : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inventoryTitleTextField.delegate = self
        descriptionTextView.delegate = self
        priceTextField.delegate = self
        quantityTextField.delegate = self
        
        getCategoriesFromServer(url: Constants.categoryUrl)
        setUI()
        setNavBarBackButton()
        setInventoryDetailFromManageVC()
        tapGestureToDismissKeyboard()
    }
    
    func setInventoryDetailFromManageVC() {
        
        if(isSelected){
            addImageButton.isHidden = true
            prodImageView.imageFromUrl(urlString: productImage)
            inventoryTitleTextField.text = inventoryTitle
            descriptionTextView.text = desc
            priceTextField.text = price
            quantityTextField.text = qty
        }
        else{
            addImageButton.isHidden = false
        }
    }
    
    func setNavBarBackButton(){
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(UIImage(named: "barBackButton"), for: .normal)
        button.addTarget(self, action:#selector(navigateBackToRoot), for: .touchDown)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItems = [barButton]
    }
    
    @objc func navigateBackToRoot(){
        navigationController?.popToRootViewController(animated: true)
    }
    
    func tapGestureToDismissKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)
    }
    
    @objc func handleTap() {
        inventoryTitleTextField.resignFirstResponder()
        descriptionTextView.resignFirstResponder()
        priceTextField.resignFirstResponder()
        quantityTextField.resignFirstResponder()
    }
    
    func setUI(){
        curvedView.layer.cornerRadius = CGFloat(Constants.BUTTON_CORNER_RADIUS)
        prodImageView.layer.masksToBounds = true
        prodImageView.layer.cornerRadius = CGFloat(Constants.VIEW_CORNER_RADIUS)
        prodImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        addImageButton.layer.cornerRadius = 5
        addNewInventoryButton.layer.cornerRadius = CGFloat(Constants.BUTTON_CORNER_RADIUS)
        inventoryTitleTextField.useUnderline()
        priceTextField.useUnderline()
        quantityTextField.useUnderline()
        
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.borderColor = UIColor.systemGray3.cgColor
        descriptionTextView.layer.cornerRadius = CGFloat(Constants.BUTTON_CORNER_RADIUS)
    }
    
    func getCategoriesFromServer(url: String){
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        request.url = URL(string: url)
        
        let task1 = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
            if(data != nil && data?.count != 0)
            {
                self.parseJson2(data: data!)
            }
        })
        task1.resume()
    }
    
    func parseJson2(data: Data){
        if let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [Any] {
            for item in json {
                if let object = item as? [String: Any] {
                    _ = object["id"] as? Int ?? 999
                    let name = object["name"] as? String ?? "N/A"
                    
                    categoryArray.append(name)
                }
            }
        }
        print("NAmes of Category:: \(categoryArray)")
        dropDown.dataSource = categoryArray
    }
    
    
    @IBAction func addImageButtonClicked(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func addForSaleButtonClicked(_ sender: Any) {
        self.view.endEditing(true)
        
        if flagSale {
            flagSale = false
            addForSaleButton.setImage(UIImage(named: "circle.png"), for: UIControl.State.normal)
        }else{
            flagSale = true
            addForSaleButton.setImage(UIImage(named: "circle-fill.png"), for: UIControl.State.normal)
        }
        addForSaleButton.imageView?.contentMode = .scaleAspectFit
    }
    
    @IBAction func addForRentButtonClicked(_ sender: Any) {
        self.view.endEditing(true)
        
        if flagRent {
            flagRent = false
            addForRentButton.setImage(UIImage(named: "circle.png"), for: UIControl.State.normal)
        }else{
            flagRent = true
            addForRentButton.setImage(UIImage(named: "circle-fill.png"), for: UIControl.State.normal)
        }
        addForRentButton.imageView?.contentMode = .scaleAspectFit
    }
    
    @IBAction func categoryDropdownButtonClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        
        //        dropDown.dataSource = categories
        dropDown.anchorView = sender
        dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height)
        dropDown.show()
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let _ = self else { return }
            //            sender.setTitle(item, for: .normal)
            self!.categoryTextLabel.text = item
        }
    }
    
    @IBAction func addNewInventoryClicked(_ sender: Any) {
        self.view.endEditing(true)
        // web service call
    }
}

extension UIViewController: UITextFieldDelegate, UITextViewDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}


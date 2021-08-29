//
//  ListPopup.swift
//  SearchableMenuPopup
//
//  Created by Srushti Dange on 29/08/21.
//

import Foundation
import UIKit

class ListPopup: UIView, UITableViewDelegate, UITableViewDataSource {
    
    //MARK:- IBOutlets
    @IBOutlet var vwContent:                            UIView!
    @IBOutlet var lblHeading:                           UILabel!
    @IBOutlet var tableView:                            UITableView!
    @IBOutlet var heightTableView:                      NSLayoutConstraint!
    @IBOutlet weak var lblNoDataFound:                  UILabel!
    @IBOutlet weak var searchBar:                       UISearchBar!
    @IBOutlet weak var warningView:                     UIView!
    @IBOutlet weak var bottomView:                      UIView!
    @IBOutlet weak var bottomViewheight:                NSLayoutConstraint!
    @IBOutlet weak var btnCancel:                       UIButton!
    
    
    //MARK:- Variables
    var convertDuplicateRecrod                          = false
    var dashboardtype                                   = ""
    var module:String                                   = ""
    var lblHeadingCount                                 = ""
    var Viewtype:                                         UIView!
    var arrTableData                                    = [[String:String]]()
    var arrFilteredData                                 = [[String:String]]()
    var btnSubmitForCheckBox:                           (([String:String]) -> Void)?
    
    //MARK:- View Life Cycle
    override func awakeFromNib() {
        self.initialConfig()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.vwContent.layoutIfNeeded()
        self.arrFilteredData = self.arrTableData
        
        self.tableView.reloadData()
        if arrTableData.count > 0 && arrTableData.count <= 8{
            self.heightTableView.constant = CGFloat(arrTableData.count * 40) + 90
        }else if arrTableData.count > 8{
            self.heightTableView.constant =  CGFloat(8 * 40) + 90
        }else{
            self.heightTableView.constant = 100 + 100
        }
    }
    
    //MARK: Private Methods
    func initialConfig() {
        self.tableView.register(UINib(nibName: "PopupCell", bundle: nil), forCellReuseIdentifier: "PopupCell")
        self.warningView.backgroundColor = UIColor.clear
        self.warningView.isHidden = true
        self.lblNoDataFound.isHidden = true
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.searchBar.delegate = self
        tableView.tableFooterView = UIView(frame: .zero)
        btnCancel.backgroundColor = .white
        searchBar.layer.borderWidth = 1.0
        searchBar.layer.borderColor = UIColor.gray.cgColor
        searchBar.placeholder = "Search"
        
        
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.backgroundColor = UIColor.white
            
            textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "", attributes: [NSAttributedStringKey.foregroundColor : UIColor.gray])
            
            if let leftView = textfield.leftView as? UIImageView {
                leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
                leftView.tintColor = UIColor.gray
            }
        }
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: nil, action: #selector(doneButtonClicked))
        toolbar.setItems([doneButton], animated: false)
        
        guard let searchField = searchBar.value(forKey: "searchField") as? UITextField else { return }
        searchField.inputAccessoryView = toolbar
    }
    
    @objc func doneButtonClicked(){
        self.endEditing(true)
    }
    
    @IBAction func btnCancel_Click(_ sender: Any) {
        self.removeFromSuperview()
    }
    
    //MARK:- TableView Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.arrFilteredData.count == 0 {
            self.tableView.isHidden = true
            self.warningView.isHidden = false
            self.lblNoDataFound.isHidden = false
            self.lblNoDataFound.text = "No Data Found"
            
        }else{
            self.tableView.isHidden = false
            self.warningView.isHidden = true
            self.lblNoDataFound.isHidden = true
        }
        return self.arrFilteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PopupCell", for: indexPath) as? PopupCell
        cell?.backgroundColor = UIColor.white
        cell?.lblTitle.text = self.arrFilteredData[indexPath.row]["value"] ?? ""
        tableView.tableFooterView = UIView(frame: .zero)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        btnSubmitForCheckBox!(self.arrFilteredData[indexPath.row])
        self.removeFromSuperview()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}


extension ListPopup: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        self.searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        var searchPredicate  = NSPredicate()
        searchPredicate = NSPredicate(format: "value CONTAINS[C] %@", searchText)
        
        self.arrFilteredData = searchText.isEmpty ? self.arrTableData : self.arrTableData.filter { searchPredicate.evaluate(with: $0) }
        self.tableView.reloadData()
    }
}

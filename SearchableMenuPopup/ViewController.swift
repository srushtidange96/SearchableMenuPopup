//
//  ViewController.swift
//  SearchableMenuPopup
//
//  Created by Srushti Dange on 29/08/21.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet weak var lblSelectedText: UILabel!
    
    @IBOutlet weak var viewListPopup: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initConfig()
        // Do any additional setup after loading the view.
    }
    
    func initConfig() {
        // Add gesture to open searchable popup
        let viewList = UITapGestureRecognizer(target: self, action: #selector(ListItems))
        viewList.numberOfTapsRequired = 1
        viewList.delegate = self as UIGestureRecognizerDelegate
        viewListPopup.addGestureRecognizer(viewList)
    }

    
    @objc func ListItems(){
        let arrData = [["value":"Gujarat"],["value":"Maharashtra"],["value":"Goa"],["value":"Kerala"],["value":"Rajasthan"],["value":"Uttrakhand"],["value":"Assam"],["value":"Tripura"],["value":"Orissa"]]
        self.showListPopup(topHeading: "List Menu", arrData: arrData, onSubmitClick: {
             arrData in
            self.lblSelectedText.text = arrData["value"] ?? ""
            print(" arr data here : ", arrData)
        })
    }
    func showListPopup(topHeading: String?, arrData: [[String : String]],onSubmitClick: @escaping ([String:String]) -> ()) {
        self.view.window?.rootViewController?.view.endEditing(true)
            var window : UIWindow!
            
            window = UIApplication.shared.windows.first!
            let popUp = Bundle.main.loadNibNamed("ListPopup", owner: self, options: nil)?[0] as! ListPopup
            popUp.frame = window.frame
            popUp.lblHeading.text = topHeading
            popUp.arrTableData = arrData
            popUp.btnSubmitForCheckBox = {(arr_Submitted) in
                onSubmitClick(arr_Submitted)
            }
            window.addSubview(popUp)
            window.bringSubview(toFront: popUp)
        }
}


//
//  ViewController.swift
//  DOBDemo
//
//  Created by VJ's iMAC on 23/09/20.
//  Copyright © 2020 VJ's. All rights reserved.
//

import UIKit
import ObjectMapper

class ViewController: UIViewController {
    
    var dobModelData : [Person?] = []
    
    @IBOutlet weak var _tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dobSortedListService()
        self._tableView.register(UINib(nibName: "PersonTableViewCell", bundle: nil), forCellReuseIdentifier: "PersonTableViewCell")
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dobModelData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonTableViewCell", for: indexPath) as! PersonTableViewCell
        let element = self.dobModelData[indexPath.row]
        let stringToDate = element?.dob
        cell.dobLabel.text = "\(stringToDate!)"
        cell.dobLabel.textColor = .red
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
extension ViewController {
    func dobSortedListService(){
        
        if let path = Bundle.main.path(forResource: "AllMenu", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                guard let jsonObj = jsonResult as? [String: AnyObject] else {
                    return print("handle error")
                }
                print(jsonObj)
                
                if let data = (jsonObj as NSDictionary).value(forKey: "data") as? NSArray {
                    let result = Mapper<Person>().mapArray(JSONObject: data)
                    
                    for i in result! {
                        let leap = !isYearLeapYear(i.dob?.toDateTime())
                        if leap {
                            self.dobModelData.append(i)
                        }
                    }
                    let dateVal = dobModelData.sorted { (($0?.dob ?? "") as String).localizedCaseInsensitiveCompare($1?.dob ?? "") == .orderedAscending}
                    self.dobModelData.removeAll()
                    self.dobModelData = dateVal
                }
                
                DispatchQueue.main.async {
                    self._tableView.reloadData()
                }
                
            } catch {
                
                print("handle error")
            }
        }
    }
}

extension String {
    func toDateTime() -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateFromString : Date = dateFormatter.date(from: self)! as Date
        return dateFromString
    }
}
extension ViewController {
    
    func isYearLeapYear(_ aDate: Date?) -> Bool {
        let year = self.year(from: aDate)
        return ((year % 100 != 0) && (year % 4 == 0)) || year % 400 == 0
    }
    
    func year(from aDate: Date?) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        var year: Int? = nil
        if let aDate = aDate {
            year = Int(dateFormatter.string(from: aDate)) ?? 0
        }
        return year ?? 0
    }
    
}

//
//  MyInfoPickerViewController.swift
//  news
//
//  Created by 奥那 on 15/12/23.
//  Copyright © 2015年 lanjing. All rights reserved.
//

import UIKit

class MyInfoPickerViewController : NSObject,UIPickerViewDataSource,UIPickerViewDelegate{
    
    weak var textField : UITextField?
    var dataArray:Array<String>?
    var multiDataArray : Array<Dictionary<String , Array<String>>>?
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        
        if self.multiDataArray != nil {
            return 2
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        if self.multiDataArray != nil {
            if component == 0 {
                return  multiDataArray!.count
            }else {
                var dict = multiDataArray![pickerView.selectedRow(inComponent: 0)]
                let key = dict.keys.first!
                let values = dict[key]
                return values!.count
            }
        }
        
        if self.dataArray == nil {
            return 0
        }
        return self.dataArray!.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if multiDataArray != nil {
            if component == 0 {
                let dict = multiDataArray![row]
                let keys = dict.keys
                return keys.first!
            }else{
                var dict = multiDataArray![pickerView.selectedRow(inComponent: 0)]
                let key = dict.keys.first!
                var values = dict[key]
                return values![row]
            }
        }
        
        if self.dataArray == nil {
            return ""
        }
        
        return self.dataArray![row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if multiDataArray != nil {
            if component == 0 {
                pickerView.reloadComponent(1)
            }
        }
    }
    func pickerDone(){
        
        let picker = textField!.inputView as! UIPickerView
        
        if multiDataArray != nil {
            let index0 = picker.selectedRow(inComponent: 0)
            let index1 = picker.selectedRow(inComponent: 1)
            
            var dict = multiDataArray![index0]
            let key0 = dict.keys.first!
            let key1 = dict[key0]![index1]
            
            let text = "\(key0) \(key1)"
            textField!.text = text
            
        }else {
            
            let index = picker.selectedRow(inComponent: 0)
            let text = self.dataArray![index]
            textField!.text = text
            
        }
        textField?.endEditing(true)
    }
    
    func pickerCancel(){
        textField?.endEditing(true)
    }
    
}

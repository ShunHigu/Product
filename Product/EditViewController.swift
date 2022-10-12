//
//  EditViewController.swift
//  Product
//
//  Created by 日暮駿之介 on 2022/10/08.
//

import UIKit
import RealmSwift

class EditViewController: UIViewController {
    
    @IBOutlet weak var titleTextField:UITextField!
    @IBOutlet weak var contentTextField:UITextView!
    @IBOutlet weak var dayTextField:UITextField!
    var j:Int!
   
    var todoTitles: Results<Memo>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let realm_1=try!Realm()
        self.todoTitles = realm_1.objects(Memo.self)
        titleTextField.text=todoTitles[j].title
        contentTextField.text=todoTitles[j].content
        dayTextField.text=todoTitles[j].day
        
        setupToolbar()
    }
    
    
//    日付をDatePickerで決める
    var toolBar:UIToolbar!
    func setupToolbar() {
        //datepicker上のtoolbarのdoneボタン
        toolBar = UIToolbar()
        toolBar.sizeToFit()
        let toolBarBtn = UIBarButtonItem(title: "DONE", style: .plain, target: self, action: #selector(doneBtn))
        toolBar.items = [toolBarBtn]
        dayTextField.inputAccessoryView = toolBar
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.preferredDatePickerStyle = .wheels
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        textField.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: UIControl.Event.valueChanged)
    }
    
    //datepickerが選択されたらtextfieldに表示
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        // 日付のフォーマット
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日"
        dayTextField.text = (formatter.string(from: Date()))
    }
    
    //toolbarのdoneボタン
    @objc func doneBtn(){
        dayTextField.resignFirstResponder()
    }
    
    @IBAction func save(_ sender: Any){
        let memo:Memo = Memo()
        memo.title=self.titleTextField.text
        memo.content=self.contentTextField.text
        memo.day=self.dayTextField.text
        
        let realm_2 = try! Realm()
        try! realm_2.write{
            realm_2.add(memo)
            realm_2.delete(self.todoTitles[j])
        }
    }
}

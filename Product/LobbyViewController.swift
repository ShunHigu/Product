//
//  LobbyViewController.swift
//  Product
//
//  Created by 日暮駿之介 on 2022/10/05.
//

import UIKit
import RealmSwift

class LobbyViewController: UIViewController, UITableViewDelegate{
    
    
    var todoTitles: Results<Memo>!
    var j:Int!
    
    @IBOutlet weak var table:UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//テーブルビューのデータソースメッそどはViewControllerに書くという設定
        table.delegate=self
        table.dataSource=self
        let realm_1=try!Realm()
        self.todoTitles = realm_1.objects(Memo.self)
    }
    
    // 画面遷移した際に、リロードして全てのリストを表示
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        table.reloadData()
    }
}

extension LobbyViewController: UITableViewDataSource{
    //セルの数を設定
    func tableView(_ tableView:UITableView,numberOfRowsInSection section:Int)->Int{
        return self.todoTitles.count
//        return 10
    }
    
    //ID付きのcellを取得して、cellのtextLabelをtestにする
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let todoTitle:Memo = self.todoTitles[(indexPath as NSIndexPath).row];
        cell.textLabel?.text = todoTitle.title
        return cell
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
//        cell?.textLabel?.text = "test"
//        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        j=indexPath.row
        performSegue(withIdentifier: "LobbyToEdit", sender: nil)
        j=indexPath.row
    }
//    @IBAction func byPerformSegue(_ sender: Any) {
//        self.performSegue(withIdentifier: "Cell", sender: nil)
//    }
//
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LobbyToEdit" {
            let editViewController:EditViewController=segue.destination as!EditViewController
            editViewController.j=self.j
        }
    }

    //TableViewを左にスワイプしたときの処理
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            
            self.DeleteTodoListRealm(indexPath: indexPath.row)
            
            completionHandler(true)
        }
    // 定義したアクションをセット
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func DeleteTodoListRealm(indexPath: Int) {
        let realm_2 = try! Realm()
        try! realm_2.write {
            realm_2.delete(self.todoTitles[indexPath])
        }
        self.table.reloadData()
    }
}


//
//  HistoryViewController.swift
//  MiniWiki
//
//  Created by Yusuf Ansar on 30/09/18.
//  Copyright © 2018 MoneyTap. All rights reserved.
//

import UIKit
import CoreData

class HistoryViewController: UIViewController {
    
    static let searchItemCellIdentifier = "SearchItemTableViewCell"
    static let articleDetailSegueIdentifier = "ArticleDetailSegue"
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var fetchedhResultController: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Article.self))
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    var selectedArticle: Article?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTableContent()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func clearButtonPressed(_ sender: UIBarButtonItem) {
        clearData()
    }
    
    func updateTableContent() {
        
        do {
            try self.fetchedhResultController.performFetch()
            self.tableView.reloadData()
        } catch let error  {
            print("ERROR: \(error)")
        }
    }
    
    private func clearData() {
        do {
            let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Article.self))
            do {
                let objects  = try context.fetch(fetchRequest) as? [NSManagedObject]
                _ = objects.map{$0.map{context.delete($0)}}
                CoreDataStack.sharedInstance.saveContext()
            } catch let error {
                print("ERROR DELETING : \(error)")
            }
        }
    }
    
    func showDetail(for article: Article) {
        selectedArticle = article
        self.performSegue(withIdentifier: HistoryViewController.articleDetailSegueIdentifier, sender: self)
    }


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ExploreViewController.articleDetailSegueIdentifier, let article = selectedArticle {
            let detailVC = segue.destination as! ArticleDetailViewController
            detailVC.htmlDescription = article.text
        }
    }
 

}

extension HistoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = fetchedhResultController.fetchedObjects?.count {
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HistoryViewController.searchItemCellIdentifier, for: indexPath) as! SearchItemTableViewCell
        
        if let article = fetchedhResultController.object(at: indexPath) as? Article {
            cell.configureCell(with: article)
        }
        return cell
    }
}
extension HistoryViewController: UITableViewDelegate {
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let article = fetchedhResultController.object(at: indexPath) as? Article {
            showDetail(for: article)
        }
    }
}

extension HistoryViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            self.tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            self.tableView.deleteRows(at: [indexPath!], with: .automatic)
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
}

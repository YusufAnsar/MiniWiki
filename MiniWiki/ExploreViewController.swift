//
//  ExploreViewController.swift
//  MiniWiki
//
//  Created by Yusuf Ansar on 30/09/18.
//  Copyright © 2018 MoneyTap. All rights reserved.
//

import UIKit

class ExploreViewController: UIViewController {
    
    static let searchItemCellIdentifier = "SearchItemTableViewCell"
    static let articleDetailSegueIdentifier = "ArticleDetailSegue"
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let searchController = UISearchController(searchResultsController: nil)
    var searchItems: [SearchItem]?
    var selectedArticle: Article?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSearchController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ExploreViewController.articleDetailSegueIdentifier, let article = selectedArticle {
            let detailVC = segue.destination as! ArticleDetailViewController
            detailVC.htmlDescription = article.text
        }
    }
    
    
    // MARK: - Private methods
    
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Wikipedia"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isSearching() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func searchWikiPedia(term: String) {
        let apiService = APIService.shared
        apiService.search(term: term) { [unowned self] (searchItems, errorMsg) in
            DispatchQueue.main.async {
                if errorMsg != nil {
                    self.showAlertWith(title: "Error", message: errorMsg!)
                } else {
                    self.searchItems = searchItems
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func showDetail(for searchItem: SearchItem) {
        let apiService = APIService.shared
        apiService.fetchSearchItemDetail(for: searchItem) { (htmlContent, errorMessssage) in
            DispatchQueue.main.async {
                if errorMessssage != nil {
                    self.showAlertWith(title: "Error", message: errorMessssage!)
                } else if (htmlContent != nil) {
                    searchItem.text = htmlContent
                    self.saveAndNavigateToDetailScreen(searchItem: searchItem)
                } else {
                    self.showAlertWith(title: "Error", message: "No content")
                }
            }
        }
    }
    
    func saveAndNavigateToDetailScreen(searchItem: SearchItem) {
        let article = Article.createArticleEntity(from: searchItem)
        CoreDataStack.sharedInstance.saveContext()
        navigateToDetailScreen(for: article)
    }
    
    func navigateToDetailScreen(for article: Article) {
        selectedArticle = article
        self.performSegue(withIdentifier: ExploreViewController.articleDetailSegueIdentifier, sender: self)
    }
    
    func showAlertWith(title: String, message: String, style: UIAlertControllerStyle = .alert) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let action = UIAlertAction(title: title, style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showLoadingIndicator() {
        view.isUserInteractionEnabled = false
        activityIndicator.startAnimating()
    }
    
    
    func hideLoadingIndicator() {
        view.isUserInteractionEnabled = true
        activityIndicator.stopAnimating()
    }

}

extension ExploreViewController: UITableViewDataSource {
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ExploreViewController.searchItemCellIdentifier, for: indexPath) as! SearchItemTableViewCell
        if let searchItem = searchItems?[indexPath.row] {
            cell.configureCell(with: searchItem)
        }
        return cell
    }
    
    

}

extension ExploreViewController: UITableViewDelegate {
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let searchItem = self.searchItems?[indexPath.row] {
            showDetail(for: searchItem)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Searching"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }

}

extension ExploreViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        searchWikiPedia(term: searchController.searchBar.text ?? "")
    }
}

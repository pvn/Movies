//
//  MasterViewController.swift
//  SonyDemo
//
//  Created by Praveen Kumar on 19/09/21.
//  Copyright © 2021 Praveen Kumar. All rights reserved.

import UIKit

enum SearchByField {
  case movieTitle
}

// default scope always matches
struct SearchScope {
  var beginsWith: String = ""
  var searchBy: SearchByField = .movieTitle
}

class MasterViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchFooter: SearchFooter!
    @IBOutlet var searchFooterBottomConstraint: NSLayoutConstraint!
    
    //  var candies: [Candy] = []
    var movies: [MovieItemView] = []
    var filteredMovies: [MovieItemView] = []
    var movieViewModel: MovieListViewModel?
    var movieSearchText = ""
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nowPlayingManger = MovieManager(delegate: self)
        nowPlayingManger.movies()
                
        // 1
        searchController.searchResultsUpdater = self
        // 2
        searchController.obscuresBackgroundDuringPresentation = false
        // 3
        searchController.searchBar.placeholder = "Search Movie"
        // 4
        navigationItem.searchController = searchController
        // 5
        definesPresentationContext = true
        
        searchController.searchBar.scopeButtonTitles = [] //Candy.Category.allCases.map { $0.rawValue }
        searchController.searchBar.delegate = self
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification,
                                       object: nil, queue: .main) { (notification) in
            self.handleKeyboard(notification: notification) }
        notificationCenter.addObserver(forName: UIResponder.keyboardWillHideNotification,
                                       object: nil, queue: .main) { (notification) in
            self.handleKeyboard(notification: notification) }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            guard
              segue.identifier == "ShowDetailSegue",
              let indexPath = tableView.indexPathForSelectedRow,
              let detailViewController = segue.destination as? MovieDetailViewController
              else {
                return
            }
        
            let movieItemView: MovieItemView
            if isFiltering {
                movieItemView = filteredMovies[indexPath.row]
            } else {
                movieItemView = movies[indexPath.row]
            }
            detailViewController.movie = movieItemView
    }
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        return searchController.isActive && (!isSearchBarEmpty)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        movieSearchText = searchText
        filteredMovies = movies.filter { (movie: MovieItemView) -> Bool in
            
            if isSearchBarEmpty {
                return true
            } else {
                return movie.search(searchText: searchText)
            }
        }
        self.tableView.reloadData()
    }
    
    func handleKeyboard(notification: Notification) {
        // 1
        guard notification.name == UIResponder.keyboardWillChangeFrameNotification else {
            searchFooterBottomConstraint.constant = 0
            view.layoutIfNeeded()
            return
        }
        
        guard
            let info = notification.userInfo,
            let keyboardFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        else {
            return
        }
        
        // 2
        let keyboardHeight = keyboardFrame.cgRectValue.size.height
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.searchFooterBottomConstraint.constant = keyboardHeight
            self.view.layoutIfNeeded()
        })
    }
}

extension MasterViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    if isFiltering {
      searchFooter.setIsFilteringToShow(filteredItemCount:
        filteredMovies.count, of: movies.count)
      return filteredMovies.count
    }
    searchFooter.setNotFiltering()
    return movies.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    let cell = tableView.dequeueReusableCell(withIdentifier: "MovieListCell", for: indexPath)
    let cell:MovieListCell = tableView.dequeueReusableCell(withIdentifier: "MovieListCell", for: indexPath) as! MovieListCell
    let movie: MovieItemView
    if isFiltering {
        movie = filteredMovies[indexPath.row]
    } else {
        movie = movies[indexPath.row]
    }
    
    cell.update(movie: movie, searchHighlightText: movieSearchText)
    
    return cell
  }
    
    
}

extension MasterViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension MasterViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchResults = movies
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
        
    }
    
    private func findMatches(searchString: String) -> NSCompoundPredicate {
        /** Each searchString creates an OR predicate for: name, yearIntroduced, introPrice.
            Example if searchItems contains "Gladiolus 51.99 2001":
                name CONTAINS[c] "gladiolus"
                name CONTAINS[c] "gladiolus", yearIntroduced ==[c] 2001, introPrice ==[c] 51.99
                name CONTAINS[c] "ginger", yearIntroduced ==[c] 2007, introPrice ==[c] 49.98
        */
        var searchItemsPredicate = [NSPredicate]()
        
        /** Below we use NSExpression represent expressions in our predicates.
            NSPredicate is made up of smaller, atomic parts:
            two NSExpressions (a left-hand value and a right-hand value).
        */
        
        // Product title matching.
        let titleExpression = NSExpression(forKeyPath: "movieTitle")
        let searchStringExpression = NSExpression(forConstantValue: searchString)
        
        let titleSearchComparisonPredicate =
        NSComparisonPredicate(leftExpression: titleExpression,
                              rightExpression: searchStringExpression,
                              modifier: .direct,
                              type: .contains,
                              options: [.caseInsensitive, .diacriticInsensitive])
        
        searchItemsPredicate.append(titleSearchComparisonPredicate)
        
                
        var finalCompoundPredicate: NSCompoundPredicate!
    
        // Handle the scoping.
        let selectedScopeButtonIndex = searchController.searchBar.selectedScopeButtonIndex
        if selectedScopeButtonIndex > 0 {
            // We have a scope type to narrow our search further.
            if !searchItemsPredicate.isEmpty {
                /** We have a scope type and other fields to search on -
                    so match up the fields of the Product object AND its product type.
                */
                let compPredicate1 = NSCompoundPredicate(orPredicateWithSubpredicates: searchItemsPredicate)
                let compPredicate2 = NSPredicate(format: "(SELF.movieTitle == %@)", selectedScopeButtonIndex)

                finalCompoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [compPredicate1, compPredicate2])
            }
        } else {
            // No scope type specified, just match up the fields of the Product object
            finalCompoundPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: searchItemsPredicate)
        }

        //Swift.debugPrint("search predicate = \(String(describing: finalCompoundPredicate))")
        return finalCompoundPredicate
    }
}

extension MasterViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!)
    }
}

extension MasterViewController: MovieListUIUseCase {
    func displayMovies(movieListVM: MovieListViewModel) {
        self.movieViewModel = movieListVM
        self.movies = self.movieViewModel?.movies ?? []
        if self.movies.count == 0 {
            showAlert(message: "There are no records")
        }
        else {
            DispatchQueue.main.async {
                self.tableView.dataSource = self
                self.tableView.reloadData()
            }
        }
    }
    
    func updateUIOnFailure(error: String) {
        showAlert(message: error)
    }
    
    func showAlert(message:String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            self.present(alert, animated: true)
        }
    }
    
}

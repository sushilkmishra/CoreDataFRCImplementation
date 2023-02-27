//
//  SearchScreen.swift
//  Assessment
//
//  Created by Sushil K Mishra on 16/02/23.
//

import UIKit
import CoreData

class SearchScreen: ViewController<SearchViewModel>  {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTable: UITableView!
    private var searchFRC = NSFetchedResultsController<NSFetchRequestResult>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actionAfterLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "All Movies"
        updateTitleBackStyle()
    }
    
    private func actionAfterLoad(){
        self.viewModel = SearchViewModel()
        self.updateFRCData(type: .all, searchText: "")
        searchBar.backgroundImage = UIImage()
    }
    private func updateFRCData(type: FeatchType, searchText: String) {
        if let frc = Movie.fetchMovieFRC(movieType: type, searchStr: searchText)  {
            searchFRC = frc
            searchFRC.delegate = self
            searchTable.reloadData()
        }
    }
    
    private func actionDetail(movie: Movie) {
        performSegue(withIdentifier: String(describing: DetailScreen.self), sender: movie)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == String(describing: DetailScreen.self)) {
            if let detailScreen = segue.destination as? DetailScreen {
                detailScreen.movieData = sender as? Movie
            }
        }
    }
    
}
// MARK: table view datasource and delegate

extension SearchScreen: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            self.updateFRCData(type: .all, searchText: "")
        } else {
            self.updateFRCData(type: .search, searchText: searchText)
        }
    }
}
// MARK: Table Datasource Delegate
extension SearchScreen: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = searchFRC.fetchedObjects?.count {
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MovieCell = tableView.dequeueReusableCell(withIdentifier: String(describing: MovieCell.self), for: indexPath) as! MovieCell
        configure(cell: cell, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let movie = searchFRC.object(at: indexPath) as? Movie {
            self.actionDetail(movie: movie)
        }
    }
    private func configure(cell: MovieCell, indexPath: IndexPath)  {
        if let movie = searchFRC.object(at: indexPath) as? Movie {
            cell.configureData(movieData: movie)
            cell.buttonFavorite.indexPath = indexPath
            cell.buttonFavorite.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        }
    }
    
    @objc func buttonAction(sender: AppButton!) {
        guard let indexPath = sender.indexPath else { return }
        if let movie = searchFRC.object(at: indexPath) as? Movie {
            viewModel.updateFavoriteStatusForUser(movie: movie)
        }
    }
}
// MARK: FRC controller Delegate
extension SearchScreen : NSFetchedResultsControllerDelegate {
    //MARK: - NSFetchedResultsController Delegate
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        searchTable.beginUpdates()
    }
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                searchTable.insertRows(at: [indexPath], with: .fade)
                searchTable.reloadRows(at: [indexPath], with: .fade)
                
            }
            break;
        case .delete:
            if let indexPath = indexPath {
                searchTable.deleteRows(at: [indexPath], with: .fade)
                if indexPath.row == 0 {
                    searchTable.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .fade)
                }
                
            }
            break;
        case .update:
            if let indexPath = indexPath, let cell = searchTable.cellForRow(at: indexPath) as? MovieCell {
                configure(cell: cell, indexPath: indexPath as IndexPath)
            }
            
            break;
        case .move:
            if let indexPath = indexPath {
                searchTable.deleteRows(at: [indexPath], with: .fade)
            }
            
            if let newIndexPath = newIndexPath {
                searchTable.insertRows(at: [newIndexPath], with: .fade)
                searchTable.reloadRows(at: [newIndexPath], with: .fade)
            }
            
            
            break;
        @unknown default:
            fatalError()
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        searchTable.endUpdates()
        
    }
}

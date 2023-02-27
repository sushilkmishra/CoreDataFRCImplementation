//
//  HomeScreen.swift
//  Assessment
//
//  Created by Sushil K Mishra on 15/02/23.
//

import UIKit
import CoreData

class HomeScreen: ViewController<HomeViewModel> {
    
    @IBOutlet weak var labelFavorite: UILabel!
    @IBOutlet weak var labelStaffPick: UILabel!
    @IBOutlet weak var favoriteCollection: UICollectionView!
    @IBOutlet weak var staffPickTable: UITableView!
    
    private var staffPickFRC = NSFetchedResultsController<NSFetchRequestResult>()
    private var fvrtFRC = NSFetchedResultsController<NSFetchRequestResult>()
    private var blockOperations: [BlockOperation] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actionAfterLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    private func actionAfterLoad(){
        self.viewModel = HomeViewModel()
        self.viewModel.updateData()
        self.updateFRCData()
        updateUI()
    }
    
    private func updateUI() {
        let yourAtt: NSMutableAttributedString = "YOUR".attrbutedStr(attribute: FontAttribute.getAttribute(typeStyle: .lightTitleHome))
        let fav: NSMutableAttributedString = " FAVORITES".attrbutedStr(attribute: FontAttribute.getAttribute(typeStyle: .boldTitleHome))
        yourAtt.append(fav)
        labelFavorite.attributedText = yourAtt
        let ourAtt: NSMutableAttributedString = "OUR".attrbutedStr(attribute: FontAttribute.getAttribute(typeStyle: .lightTitleHome))
        let sp: NSMutableAttributedString = " STAFF PICK".attrbutedStr(attribute: FontAttribute.getAttribute(typeStyle: .boldTitleHome))
        ourAtt.append(sp)
        labelStaffPick.attributedText = ourAtt
    }
    
    private func updateFRCData() {
        if let frc = Movie.fetchMovieFRC(movieType: .staffPick)  {
            staffPickFRC = frc
            staffPickFRC.delegate = self
            staffPickTable.reloadData()
        }
        if let frc = Movie.fetchMovieFRC(movieType: .favorite)  {
            fvrtFRC = frc
            fvrtFRC.delegate = self
            favoriteCollection.reloadData()
        }
    }
    
    deinit {
        // Cancel all block operations when VC deallocates
        for operation: BlockOperation in blockOperations {
            operation.cancel()
        }
        blockOperations.removeAll(keepingCapacity: false)
    }
    @IBAction func actionSearch(_ sender: Any) {
        performSegue(withIdentifier: String(describing: SearchScreen.self), sender: self)
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

// MARK: Collection view datasource and delegate

extension HomeScreen: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = fvrtFRC.fetchedObjects?.count {
            return count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: FavoriteCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: FavoriteCell.self), for: indexPath) as! FavoriteCell
        if let movie = fvrtFRC.object(at: indexPath) as? Movie {
            cell.configureData(movieData: movie)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let movie = fvrtFRC.object(at: indexPath) as? Movie {
            self.actionDetail(movie: movie)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 182, height: 270)
    }
}
// MARK: table view datasource and delegate
extension HomeScreen: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = staffPickFRC.fetchedObjects?.count {
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
        if let movie = staffPickFRC.object(at: indexPath) as? Movie {
            self.actionDetail(movie: movie)
        }
    }
    private func configure(cell: MovieCell, indexPath: IndexPath)  {
        if let movie = staffPickFRC.object(at: indexPath) as? Movie {
            cell.configureData(movieData: movie)
            cell.buttonFavorite.indexPath = indexPath
            cell.buttonFavorite.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        }
    }
    
    @objc func buttonAction(sender: AppButton!) {
        guard let indexPath = sender.indexPath else { return }
        if let movie = staffPickFRC.object(at: indexPath) as? Movie {
            viewModel.updateFavoriteStatusForUser(movie: movie)
        }
    }
}

//MARK: - NSFetchedResultsController Delegate
extension HomeScreen : NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if controller == staffPickFRC {
            staffPickTable.beginUpdates()
        }
        else{
            blockOperations.removeAll(keepingCapacity: false)
        }
    }
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                if controller == staffPickFRC {
                    staffPickTable.insertRows(at: [indexPath], with: .fade)
                    staffPickTable.reloadRows(at: [indexPath], with: .fade)
                } else {
                    blockOperations.append(
                        BlockOperation(block: { [weak self] in
                            if let this = self {
                                this.favoriteCollection!.insertItems(at: [newIndexPath!])
                            }
                        })
                    )
                }
                
            }
            break;
        case .delete:
            if let indexPath = indexPath {
                if controller == staffPickFRC {
                    staffPickTable.deleteRows(at: [indexPath], with: .fade)
                    if indexPath.row == 0 {
                        staffPickTable.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .fade)
                    }
                } else {
                    blockOperations.append(
                        BlockOperation(block: { [weak self] in
                            if let this = self {
                                this.favoriteCollection!.deleteItems(at: [indexPath])
                            }
                        })
                    )
                }
            }
            break;
        case .update:
            if controller == staffPickFRC {
                if let indexPath = indexPath, let cell = staffPickTable.cellForRow(at: indexPath) as? MovieCell {
                    configure(cell: cell, indexPath: indexPath as IndexPath)
                }
            } else {
                if let indexPath = indexPath {
                    blockOperations.append(
                        BlockOperation(block: { [weak self] in
                            if let this = self {
                                this.favoriteCollection!.reloadItems(at: [indexPath])
                            }
                        })
                    )
                }
                
            }
            break;
        case .move:
            if controller == staffPickFRC {
                if let indexPath = indexPath {
                    staffPickTable.deleteRows(at: [indexPath], with: .fade)
                }
                
                if let newIndexPath = newIndexPath {
                    staffPickTable.insertRows(at: [newIndexPath], with: .fade)
                    staffPickTable.reloadRows(at: [newIndexPath], with: .fade)
                }
            } else {
                if let indexPath = indexPath, let newIndexPath = newIndexPath {
                    blockOperations.append(
                        BlockOperation(block: { [weak self] in
                            if let this = self {
                                this.favoriteCollection!.moveItem(at: indexPath, to: newIndexPath)
                            }
                        })
                    )
                }
                
            }
            
            break;
        @unknown default:
            fatalError()
        }
    }
    
    
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if controller == staffPickFRC {
            staffPickTable.endUpdates()
        } else {
            favoriteCollection!.performBatchUpdates({ () -> Void in
                for operation: BlockOperation in self.blockOperations {
                    operation.start()
                }
            }, completion: { (finished) -> Void in
                self.blockOperations.removeAll(keepingCapacity: false)
            })
        }
        
    }
}

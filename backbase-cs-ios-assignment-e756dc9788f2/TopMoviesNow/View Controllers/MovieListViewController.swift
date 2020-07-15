//
//  ViewController.swift
//  CS_iOS_Assignment
//
//  Copyright © 2019 Backbase. All rights reserved.
//

import UIKit

class MovieListViewController: UIViewController {
    
    var popularViewModel: PopularMoviesViewModel
    var tableView: UITableView?
    
    init(popViewModel: PopularMoviesViewModel = PopularMoviesViewModel(), npViewModel: NowPlayingMoviesViewModel = NowPlayingMoviesViewModel()) {
        self.popularViewModel = popViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("This shouldn't happen")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpTableView()
        
        self.popularViewModel = PopularMoviesViewModel()
        self.popularViewModel.bind {
            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }
        }
        self.popularViewModel.fetchMovies()
        self.navigationItem.title = "MOVIES"
        self.navigationController?.navigationBar.backgroundColor = .black
    }
    
    private func setUpTableView() {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.backgroundColor = .black
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        
        tableView.register(NowPlayingCell.self, forCellReuseIdentifier: NowPlayingCell.reuseIdentifier)
        tableView.register(PopularMovieCell.self, forCellReuseIdentifier: PopularMovieCell.reuseIdentifier)
        
        self.view.addSubview(tableView)
        tableView.boundToSuperView(inset: 0)
        self.tableView = tableView
    }
    

}

extension MovieListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard indexPath.section == 1 else { return }
        self.navigateToDetail(with: indexPath.row, viewModel: self.popularViewModel)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.backgroundView?.backgroundColor = .darkGray
        header.textLabel?.textColor = .systemYellow
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
}

extension MovieListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return (section == 0) ? "Playing now" : "Most popular"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (indexPath.section == 0) ? 150 : UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (section == 0) ? 1 : self.popularViewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NowPlayingCell.reuseIdentifier, for: indexPath) as? NowPlayingCell else {
                return UITableViewCell()
            }
            cell.setDelegate(delegate: self)
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PopularMovieCell.reuseIdentifier, for: indexPath) as? PopularMovieCell else {
                return UITableViewCell()
            }
            
            cell.titleLabel?.setAttrString(text: self.popularViewModel.title(index: indexPath.row), isBold: true)
            cell.releaseDateLabel?.setAttrString(text: self.popularViewModel.releaseDate(index: indexPath.row), isBold: false)
            cell.ratingView?.percentage = self.popularViewModel.rating(index: indexPath.row)
            self.setImage(cell: cell, index: indexPath.row)
            self.getDetails(cell: cell, index: indexPath.row)
            
            return cell
        }
    }
    
    private func setImage(cell: PopularMovieCell, index: Int) {
        self.popularViewModel.fetchImage(index: index) { (image) in
            DispatchQueue.main.async {
                cell.moviePosterView?.image = image ?? UIImage(named: "Default.jpeg")
            }
        }
    }
    
    private func getDetails(cell: PopularMovieCell, index: Int) {
        self.popularViewModel.fetchIndividualFilm(index: index) { (duration) in
            DispatchQueue.main.async {
                cell.durationLabel?.setAttrString(text: duration, isBold: false)
            }
        }
    }
}

extension MovieListViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let lastCellIndexPath = IndexPath(row: self.popularViewModel.count - 1, section: 1)
        guard indexPaths.contains(lastCellIndexPath) else { return }
        self.popularViewModel.fetchMovies()
    }
    
}

extension MovieListViewController: CellSelectedDelegate {
    
    func navigateToDetail(with index: Int, viewModel: ViewModelType) {
        DispatchQueue.main.async {
            let detailVC = MovieDetailViewController(viewModel: viewModel, index: index, delegate: self)
            let navVC = UINavigationController()
            navVC.viewControllers = [detailVC]
            navVC.navigationBar.barTintColor = .clear
            self.modalPresentationStyle = .overFullScreen
            self.present(navVC, animated: true, completion: nil)
        }
    }
    
}

extension MovieListViewController: DismissDetailDelegate {
    
    func dismissDetail() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
}

//
//  LocationViewController.swift
//  Lidora
//
//  Created by Kerby Jean on 9/6/20.
//

import UIKit
import MapKit


class LocationViewController: UIViewController {
    
    var tableView: UITableView!
    var searchBar = UISearchBar()
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    func setupViews() {
        view.backgroundColor = .white
        self.title = "Change location"
        
        let doneButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        doneButtonItem.isEnabled = false
        navigationItem.rightBarButtonItem = doneButtonItem
        
        searchCompleter.delegate = self

        searchBar.searchBarStyle = .prominent
        searchBar.placeholder = " Search your address"
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "cancel-24"), style: .done, target: self, action: #selector(cancel))
        navigationController?.navigationBar.tintColor = .darkText
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height), style: .plain)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.addSubview(searchBar)
        
        view.addSubview(tableView)
    }
    

    @objc func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func done() {
        
    }
}

extension LocationViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCompleter.queryFragment = searchText
    }
}



extension LocationViewController: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        tableView.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("An error occured MKLocalSearchCompleter: ", error)
    }
}


extension LocationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        let searchResult = searchResults[indexPath.row]
        let originalImage = UIImage(systemName: "location")
        let image = originalImage?.withTintColor(.gray, renderingMode: .alwaysOriginal)

        cell.imageView?.image = image
        cell.textLabel?.text = searchResult.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedResult = self.searchResults[indexPath.row]
        navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    
}

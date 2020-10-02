//
//  LocationViewController.swift
//  Lidora
//
//  Created by Kerby Jean on 9/6/20.
//

import UIKit
import MapKit

enum LocationType {
    case register
    case update
}

class LocationViewController: UIViewController {
    
    var tableView: UITableView!
    var searchBar = UISearchBar()
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    var currentAddress: String?
    var locationType = LocationType.update
    
    lazy var buttonView: UIView = {
        let view = UIView()
        view.frame =  CGRect(x: 0, y: 0, width: view.frame.size.width, height: 60)
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowRadius = 5.0
        let button = LoadingButton(type: .custom)
        button.enable()
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 5.0
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.setTitle("Save", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(done), for: .touchUpInside)
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -60),
            button.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -20),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        return view
    }()
    
    var delegate: LocationDelegate?
    var doneButtonItem: UIBarButtonItem!
    
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
        searchCompleter.resultTypes = [.address]
        searchCompleter.delegate = self
        
        searchBar.frame = CGRect(x: 0, y: 60, width: view.frame.width, height: 60)
        searchBar.searchBarStyle = .prominent
        searchBar.placeholder = "Enter a new address"
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        searchBar.inputAccessoryView = buttonView
        searchBar.becomeFirstResponder()

        view.addSubview(searchBar)
        
        navigationController?.navigationBar.tintColor = .darkText
        
        tableView = UITableView(frame: CGRect(x: 0, y: 120, width: view.frame.width, height: view.frame.height - 60), style: .plain)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    
    @objc func done() {
        if locationType == .register {
            self.title = "Delivery Location"
            let sceneDelegate = self.view.window?.windowScene?.delegate as! SceneDelegate
            sceneDelegate.observeAuthorisedState()
        } else {
            self.title = "Change Location"
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    
    
    func updateCurrentLocation() {
        if currentAddress == nil {
            
        }
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
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
        let originalImage = UIImage(systemName: "location")
        let image = originalImage?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        cell.imageView?.image = image
        let searchResult = searchResults[indexPath.row]
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedResult = self.searchResults[indexPath.row]
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = selectedResult.title
        let search = MKLocalSearch(request: request)
        search.start { (response, error) -> Void in
            if response == nil{
                return
            }
            if let item = response?.mapItems.first {
                let placemark = item.placemark
                if let line1 = placemark.name, let postalCode = placemark.postalCode, let state = placemark.administrativeArea, let city = placemark.locality {
                    self.delegate?.location(line1: line1, postalCode: postalCode, city: city, state: state)
                    DataService.shared.updateUserLocation(line1: line1, postalCode: postalCode, city: city, state: state) { (success, error) in
                        if !success! {
                            print("Error: ", error)
                        }
                    }
                }
            }
        }
        navigationItem.rightBarButtonItem?.isEnabled = true
    }
}

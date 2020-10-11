//
//  ScheduleViewController.swift
//  Lidora
//
//  Created by Kerby Jean on 9/11/20.
//

import UIKit

class ScheduleViewController: UIViewController {
    
    var tableView: UITableView!
    var providerId: String?
    var schedule = [Schedule]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchSchedule()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        self.title = "Schedule"
        self.view.backgroundColor = .white
        
        tableView = UITableView(frame: view.frame, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
    }
    
    func fetchSchedule() {
        self.schedule.removeAll()
        DataService.shared.fetchSchedule(providerId: providerId!) { (schedule) in
            self.schedule.append(schedule)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

// MARK: - UITableViewDelegate/UITableViewDataSource

extension ScheduleViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        schedule.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: UITableViewCell.id)
        let schedule = self.schedule[indexPath.row]
        cell.textLabel?.text = schedule.day.capitalized
        cell.detailTextLabel?.text = schedule.time
        return cell
    }
}

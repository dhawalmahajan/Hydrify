//
//  DailyWaterLogController.swift
//  Hydrify
//
//  Created by Dhawal Mahajan on 26/05/24.
//

import UIKit

class DailyWaterLogController: UIViewController {
    private let viewModel = DailyWaterLogViewModel()
    fileprivate lazy var dailyTotalLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "daily total"
        return label
    }()
  
    
  
    fileprivate lazy var logTable: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(LogTableCell.self, forCellReuseIdentifier: LogTableCell.identifier)
        return tv
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(dailyTotalLabel)
        view.addSubview(logTable)
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
        setUpconstraint()
        viewModel.fetchLogsForToday()
        viewModel.requestNotificationPermission()
        viewModel.scheduleHydrationReminder()
        logTable.reloadData()
        // Do any additional setup after loading the view.
        dailyTotalLabel.text = viewModel.getDailyTotal()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchLogsForToday()
        logTable.reloadData()
    }
    private func setUpconstraint() {
        NSLayoutConstraint.activate([
            
            dailyTotalLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dailyTotalLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            dailyTotalLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
         
            logTable.topAnchor.constraint(equalTo: dailyTotalLabel.bottomAnchor),
            logTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            logTable.leadingAnchor.constraint(equalTo: dailyTotalLabel.leadingAnchor),
            logTable.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            
        ])
    }
    @objc func addButtonTapped(_ sender: UIBarButtonItem) {
        let addLogController = AddWaterLogController(waterlogViewModel: viewModel)
        navigationController?.pushViewController(addLogController, animated: true)

    }
  
}

extension DailyWaterLogController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getNumberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        viewModel.cellForRowAt(tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let editLog = AddWaterLogController(waterlogViewModel: viewModel, log: viewModel.waterLog[indexPath.row])
        show(editLog, sender: nil)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                
                viewModel.deleteLog(log: viewModel.waterLog[indexPath.row])
                
            }
        }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

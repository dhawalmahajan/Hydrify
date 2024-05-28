//
//  DailyWaterLogController.swift
//  Hydrify
//
//  Created by Dhawal Mahajan on 26/05/24.
//

import UIKit
import Combine

class DailyWaterLogController: UIViewController {
    //MARK: PROPERTIES
    private var viewModel: HydrationLogViewModel!
    private var cancellables: Set<AnyCancellable> = []
    
    //MARK: UI
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
    
    //MARK: VIEW LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(dailyTotalLabel)
        view.addSubview(logTable)
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
        setUpconstraint()
        viewModel = HydrationLogViewModel(coreDataManager: CoreDataManager())
        logTable.reloadData()
        viewModel.$totalDailyIntake.sink { [weak self] intake in
           self?.dailyTotalLabel.text = String(format:  "Total: %.2f Liter", intake)
         }.store(in: &cancellables)
        viewModel.requestNotificationPermission()
        viewModel.scheduleHydrationReminder()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        logTable.reloadData()
    }
    
    //MARK:PRIVATE FUNCTIONS
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
    
    private func bindViewModel() {
       viewModel.$entries.sink { [weak self] entries in
         self?.logTable.reloadData()
       }.store(in: &cancellables)
     }
    
    @objc func addButtonTapped(_ sender: UIBarButtonItem) {
        let addLogController = AddWaterLogController(waterlogViewModel: viewModel)
        navigationController?.pushViewController(addLogController, animated: true)
    }
  
}

extension DailyWaterLogController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LogTableCell.identifier, for: indexPath) as? LogTableCell else {return UITableViewCell()}
        cell.configureCell(with: viewModel.entries[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let editLog = AddWaterLogController(waterlogViewModel: viewModel, log: viewModel.entries[indexPath.row])
        show(editLog, sender: nil)
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true // Allow editing for all rows
      }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
      return .delete // Set editing style to delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                viewModel.deleteEntry(entry: viewModel.entries[indexPath.row])
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

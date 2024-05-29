//
//  AddWaterLogController.swift
//  Hydrify
//
//  Created by Dhawal Mahajan on 26/05/24.
//

import UIKit
import Combine

class AddWaterLogController: UIViewController {
    private let waterlogViewModel:HydrationLogViewModel
     let addWaterlogViewModel:AddWaterLogViewModel
     var log:WaterLog? = nil
    private var cancellables: Set<AnyCancellable> = []
    
    //MARK: INITIALIZER
    init(waterlogViewModel:HydrationLogViewModel) {
        self.waterlogViewModel = waterlogViewModel
        self.addWaterlogViewModel = AddWaterLogViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(waterlogViewModel:HydrationLogViewModel,log: WaterLog?) {
        self.init(waterlogViewModel: waterlogViewModel)
        self.log = log
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: UI COMPONENTS
     lazy var picker : UIPickerView = {
        let picker = UIPickerView()
        
        picker.dataSource = self // Set yourself as the data source
        picker.delegate = self // Set yourself as the delegate
        return picker
    }()
     lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.alignment = .fill
        sv.distribution = .fillEqually
        sv.axis = .vertical
        sv.spacing = 20
        sv.isLayoutMarginsRelativeArrangement = true
        sv.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
     lazy var dateButton:UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(systemName: "calendar"), for: .normal)
        btn.setTitle("Select Date", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(showPicker), for: .touchUpInside)
        return btn
    }()
     lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        return label
    }()
     lazy var quantityTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.keyboardType = .numberPad
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.lightGray.cgColor
        tf.placeholder = "quantity"
        return tf
    }()
     lazy var unitTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.lightGray.cgColor
        tf.placeholder = "unit"
        return tf
    }()
    
     lazy var saveBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Save", for: .normal)
        btn.backgroundColor = .systemBlue
        btn.layer.cornerRadius = 5
        btn.setTitleColor(.white, for: .normal)
        btn.addTarget(self, action: #selector(saveLog), for: .touchUpInside)
        return btn
    }()
     lazy var datePicker:UIDatePicker  =  {
        let dp = UIDatePicker()
        dp.datePickerMode = .date
        dp.preferredDatePickerStyle = .wheels
        dp.addTarget(self, action: #selector(didChangeDate(_:)), for: .valueChanged)
        dp.minimumDate = Date()
        
        return dp
    }()
    
     lazy var unitToolbar: UIToolbar = {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(pickerDoneButtonTapped))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        //        unitTextField.inputAccessoryView = toolbar
        return toolbar
    }()
    
    //MARK: VIEW LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        addViews()
        if let log = log {
            unitTextField.text = log.unit
            quantityTextField.text = "\(log.quantity)"
            if let date = log.date {
                let newdate = addWaterlogViewModel.formatDateToString(date:  date)
                if let newdate2  = addWaterlogViewModel.convertStringToDate(stringDate: newdate) {
                    addWaterlogViewModel.selectedDate = newdate2
                }
//                dateLabel.text = addWaterlogViewModel.formatDateToString()
            }
        }
        addWaterlogViewModel.$selectedDate.sink {[weak self] date in
            self?.dateLabel.text = "\(date)"
        }.store(in: &cancellables)
        // Do any additional setup after loading the view.
    }
    
    private func addViews() {
        stackView.addArrangedSubview(quantityTextField)
        stackView.addArrangedSubview(unitTextField)
        stackView.addArrangedSubview(dateLabel)
        stackView.addArrangedSubview(dateButton)
        stackView.addArrangedSubview(saveBtn)
        unitTextField.inputView = picker
        view.addSubview(stackView)
        setUpconstraint()
        unitTextField.inputAccessoryView = unitToolbar
        
    }
    
    private func setUpconstraint() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            //            stackView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func isFormFilledValid() -> Bool{
        if  quantityTextField.text == nil || quantityTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? false {
            return false
        }
        if unitTextField.text == nil || unitTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? false {
            return false
        }
        if dateLabel.text == "" { return false }
        
        return true
    }
    
}

//MARK: LISTNER FUNCTIONS
extension AddWaterLogController {
    @objc func saveLog() {
        if addWaterlogViewModel.isFormFilledValid(qunatity: quantityTextField.text, unit: unitTextField.text, date:  addWaterlogViewModel.formatDateToString(date: addWaterlogViewModel.selectedDate)) {
            if let log = log {
                
                waterlogViewModel.updateEntry(entry: log, date: addWaterlogViewModel.convertStringFromDateToDate() ?? Date(), newQuantity: Double(quantityTextField.text ?? "0") ?? 0, unit: unitTextField.text ?? "")
                
            } else {
                waterlogViewModel.addEntry(date: addWaterlogViewModel.convertStringFromDateToDate() ?? Date(), quantity: Double(quantityTextField.text ?? "0") ?? 0, unit: unitTextField.text ?? "")
                
            }
            navigationController?.popViewController(animated: true)
        }
        else {
            let alertController = UIAlertController(title: "Failed", message: "Please fill form correctly!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    @objc func didChangeDate(_ sender: UIDatePicker) -> Void {
        addWaterlogViewModel.selectedDate = sender.date
        addWaterlogViewModel.selectedDate = addWaterlogViewModel.convertStringFromDateToDate() ?? Date()
//        dateLabel.text = addWaterlogViewModel.formatDateToString(
        
    }
    @objc func showPicker(_ sender: UIButton) {
        datePicker.isHidden = !datePicker.isHidden
        if !datePicker.isHidden {
            let buttonFrame = saveBtn.frame // Get button frame
            let convertedFrame = view.convert(buttonFrame, from: sender.superview) // Convert to view coordinates
            datePicker.frame = CGRect(x: convertedFrame.minX,
                                      y: convertedFrame.maxY,
                                      width: convertedFrame.width,
                                      height: 200)
            view.addSubview(datePicker) // Add date picker to view
        } else {
            datePicker.removeFromSuperview() // Remove date picker from view
        }
    }
    @objc func pickerDoneButtonTapped(_ sender: Any) {
        unitTextField.resignFirstResponder() // Dismiss the picker
        quantityTextField.resignFirstResponder()
    }
}
//MARK: PICKER DELEGATES AND DATASOURCE
extension AddWaterLogController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // Single component
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return waterlogViewModel.allUnits.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return waterlogViewModel.allUnits[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        unitTextField.text = waterlogViewModel.allUnits[row].rawValue
    }
}

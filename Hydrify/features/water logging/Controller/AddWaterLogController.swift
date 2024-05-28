//
//  AddWaterLogController.swift
//  Hydrify
//
//  Created by Dhawal Mahajan on 26/05/24.
//

import UIKit

class AddWaterLogController: UIViewController {
    private let waterlogViewModel:DailyWaterLogViewModel
    private var log:WaterLog? = nil
    init(waterlogViewModel:DailyWaterLogViewModel) {
        self.waterlogViewModel = waterlogViewModel
        super.init(nibName: nil, bundle: nil)
    }
    convenience init(waterlogViewModel:DailyWaterLogViewModel,log: WaterLog?) {
        self.init(waterlogViewModel: waterlogViewModel)
        self.log = log
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate lazy var picker : UIPickerView = {
        let picker = UIPickerView()
       
        picker.dataSource = self // Set yourself as the data source
        picker.delegate = self // Set yourself as the delegate
        return picker
    }()
    fileprivate lazy var stackView: UIStackView = {
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
    fileprivate lazy var dateButton:UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(systemName: "calendar"), for: .normal)
        btn.addTarget(self, action: #selector(showPicker), for: .touchUpInside)
        return btn
    }()
    fileprivate lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        return label
    }()
    fileprivate lazy var quantityTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.keyboardType = .numberPad
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.lightGray.cgColor
        tf.placeholder = "quantity"
        return tf
    }()
    fileprivate lazy var unitTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.lightGray.cgColor
        tf.placeholder = "unit"
        return tf
    }()
   
    fileprivate lazy var saveBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Save", for: .normal)
        btn.backgroundColor = .systemBlue
        btn.layer.cornerRadius = 5
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(saveLog), for: .touchUpInside)
        return btn
    }()
    fileprivate lazy var datePicker:UIDatePicker  =  {
        let dp = UIDatePicker()
        dp.datePickerMode = .date
        dp.preferredDatePickerStyle = .wheels
            dp.addTarget(self, action: #selector(didChangeDate(_:)), for: .valueChanged)
        return dp
    }()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        addViews()
        if let log = log {
            unitTextField.text = log.unit
            quantityTextField.text = "\(log.quantity)"
            dateLabel.text = "\(log.date ?? Date())"
        }
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
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(pickerDoneButtonTapped))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        unitTextField.inputAccessoryView = toolbar
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
        if  quantityTextField.text == nil || unitTextField.text == nil {
            return false
        }
        
       return true
    }

}

//MARK: LISTNER FUNCTIONS
extension AddWaterLogController {
    @objc func saveLog() {
        waterlogViewModel.addLog(date: datePicker.date, quantity: Double(quantityTextField.text ?? "0") ?? 0, unit: unitTextField.text ?? "")
        navigationController?.popViewController(animated: true)
    }
    
    @objc func didChangeDate(_ sender: UIDatePicker) -> Void {
        dateLabel.text = " \(sender.date)"
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

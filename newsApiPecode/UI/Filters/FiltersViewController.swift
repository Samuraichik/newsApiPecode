//
//  FiltersViewController.swift
//  newsApiPecode
//
//  Created by Oleksiy Humenyuk on 15.06.2022.
//

import UIKit

class FiltersViewController: UIViewController {
    // MARK: - Public
    
    public var delegate: NewsListViewControllerDelegate?
    // MARK: - Private
    
    private var viewModel: FiltersViewModel = FiltersViewModelImpl()
    
    // MARK: - UI
    
    private lazy var segmentControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["Category","Country", "Source"])
        segment.selectedSegmentIndex = 0
        segment.addTarget(self, action: #selector(segmentAction(_:)), for: .valueChanged)
        return segment
    }()
    
    private lazy var pickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()
    // MARK: - Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.viewModel.setPickerState(state: .category)
        setUpViews()
        setUpNavigationbar()
    }
    // MARK: - Actions
    
    @objc func acceptButtonDidTapped() {
        guard let params = (self.viewModel.acceptButtonDidTapped()) else {return}
        
        delegate?.infoWasDelegated(params: params)
        self.navigationController?.popViewController(animated: true)
    }
    // MARK: - Private
    
    private func setUpNavigationbar() {
        applyDefaultNavigationBar()
        
        let acceptButton = UIBarButtonItem(image: nil,
                                           style: .done,
                                           target: self,
                                           action: #selector(acceptButtonDidTapped))
        acceptButton.title = "Accept"
        navigationItem.rightBarButtonItem = acceptButton
    }
    
    private func setUpViews() {
        view.addSubview(segmentControl)
        segmentControl.layout {
            $0.constraint(to: self.view, by: .top(70))
            $0.size(.height(40), .width(250))
            $0.centerX.constraint(to: self.view, by: .centerX(0))
        }
        
        view.addSubview(pickerView)
        pickerView.layout {
            $0.top.constraint(to: segmentControl, by: .bottom(10))
            $0.size(.height(150), .width(200))
            $0.centerX.constraint(to: self.view, by: .centerX(0))
        }
    }
}

extension FiltersViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.viewModel.getArrCount()
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.viewModel.selectedParameters = SelectedParameters(source: nil, country: nil, category: nil)
        return self.viewModel.getPickerState(row: row)
    }
    
    @objc func segmentAction(_ segmentedControl: UISegmentedControl) {
        switch  segmentedControl.selectedSegmentIndex {
        case  0:
            self.viewModel.setPickerState(state: .category)
            pickerView.reloadAllComponents()
        case  1:
            self.viewModel.setPickerState(state: .country)
            pickerView.reloadAllComponents()
        case  2:
            self.viewModel.setPickerState(state: .source)
            pickerView.reloadAllComponents()
        default:
            break
        }
    }
}

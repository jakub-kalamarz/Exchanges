//
//  ExchangesListView.swift
//  Exchanges
//
//  Created by Jakub Kalamarz on 28/01/2021.
//

import Combine
import UIKit

class ExchangesListView: UIViewController {
    var viewModel: ExchangesListViewModel!
    var canncelables = Set<AnyCancellable>()

    var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupBindings()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selected = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selected, animated: false)
        }
        viewModel.reloadData()
    }
}

// MARK: Setup Bindings

extension ExchangesListView {
    private func setupBindings() {
        viewModel.$data
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.tableView.reloadData()
                self?.navigationItem.rightBarButtonItem?.isEnabled = true
            })
            .store(in: &canncelables)

        viewModel.chooseBase.sink(receiveValue: { [weak self] _ in
            self?.showBaseChooser()
        })
            .store(in: &canncelables)
    }
}

// MARK: Setup UI

extension ExchangesListView {
    private func setupUI() {
        setupNavigation()
        setupView()
    }

    private func setupView() {
        view.backgroundColor = .systemBackground
        tableView = UITableView(frame: view.bounds, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }

    private func setupNavigation() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = viewModel.title
        let chooseBaseButton = UIBarButtonItem(image: UIImage(systemName: "dollarsign.square"), style: .plain, target: self, action: #selector(chooseBase))
        chooseBaseButton.isEnabled = false
        navigationItem.rightBarButtonItem = chooseBaseButton
    }

    @objc func chooseBase() {
        viewModel.chooseBase.send()
    }
}

// MARK: Setup Tableview

extension ExchangesListView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        viewModel.data.count
    }

    func tableView(_: UITableView, titleForHeaderInSection _: Int) -> String? {
        return "Rates"
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = viewModel.data[indexPath.row]
        return configureCell(data)
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currency = viewModel.data[indexPath.row]
        viewModel.selectedCurrency.send(currency)
    }

    private func configureCell(_ data: Rate) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        cell.textLabel?.text = data.currency
        cell.detailTextLabel?.text = String(format: "%.3f", data.value)
        cell.accessoryView = data.isFavorite ? UIImageView(image: UIImage(systemName: "heart.fill")?.withTintColor(.red)) : UIImageView(image: UIImage(systemName: "heart"))
        return cell
    }
}

// MARK: Base Pick Methods

extension ExchangesListView: UIPickerViewDelegate, UIPickerViewDataSource {
    private func showBaseChooser() {
        let vc = UIViewController()

        let pickerView = UIView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.backgroundColor = .systemBackground
        pickerView.layer.cornerRadius = 12
        pickerView.layer.masksToBounds = true

        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        picker.translatesAutoresizingMaskIntoConstraints = false

        vc.view.addSubview(pickerView)
        pickerView.addSubview(picker)

        NSLayoutConstraint.activate([
            pickerView.leadingAnchor.constraint(equalTo: vc.view.safeAreaLayoutGuide.leadingAnchor),
            pickerView.trailingAnchor.constraint(equalTo: vc.view.safeAreaLayoutGuide.trailingAnchor),
            pickerView.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor),
            picker.leadingAnchor.constraint(equalTo: pickerView.leadingAnchor),
            picker.trailingAnchor.constraint(equalTo: pickerView.trailingAnchor),
            picker.bottomAnchor.constraint(equalTo: vc.view.safeAreaLayoutGuide.bottomAnchor),
            picker.heightAnchor.constraint(equalTo: pickerView.heightAnchor),
        ])

        navigationController?.present(vc, animated: true, completion: { [weak self] in
            let base = Defaults.shared.getBase()
            let baseRow = self?.viewModel.currencySorted.firstIndex(where: { $0.currency == base }) ?? 0
            picker.selectRow(baseRow, inComponent: 0, animated: true)
        })
    }

    @objc
    private func hideBaseChooser() {
        print("xd")
    }

    func pickerView(_: UIPickerView, numberOfRowsInComponent _: Int) -> Int {
        return viewModel.currencySorted.count
    }

    func numberOfComponents(in _: UIPickerView) -> Int {
        1
    }

    func pickerView(_: UIPickerView, titleForRow row: Int, forComponent _: Int) -> String? {
        let data = viewModel.currencySorted[row]
        return data.currency
    }

    func pickerView(_: UIPickerView, didSelectRow row: Int, inComponent _: Int) {
        let data = viewModel.currencySorted[row]
        viewModel.selectedBase.send(data.currency)
    }
}

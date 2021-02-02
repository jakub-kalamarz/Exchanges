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

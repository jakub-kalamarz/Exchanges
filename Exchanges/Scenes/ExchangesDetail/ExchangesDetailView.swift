//
//  ExchangesDetailView.swift
//  Exchanges
//
//  Created by Jakub Kalamarz on 28/01/2021.
//

import UIKit
import Combine

class ExchangesDetailView: UIViewController {
    var viewModel: ExchangesDetailViewModel!

    var tableView:UITableView!

    var canncelables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
}

//MARK: Setup UI
extension ExchangesDetailView {
    private func setupUI() {
        setupNavigation()
        setupView()
        setupBindings()

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

//MARK: Setup Bindings
extension ExchangesDetailView {
    private func setupBindings() {
        viewModel.$data
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
            self?.tableView.reloadData()
        })
        .store(in: &canncelables)
    }
}

//MARK: Setup Tableview
extension ExchangesDetailView: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.data.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Rates"
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = viewModel.data[indexPath.row]
        return configureCell(data)
    }

    private func configureCell(_ data: Rate) -> UITableViewCell {
        let cell = UITableViewCell(style: .value2, reuseIdentifier: "cellDetail")
        cell.textLabel?.text = Calendar.current.getStringFromDate(date: data.date)
        cell.detailTextLabel?.text = String(data.value)
        return cell
    }
}

//
//  ExchangesDetailView.swift
//  Exchanges
//
//  Created by Jakub Kalamarz on 28/01/2021.
//

import Combine
import UIKit

class ExchangesDetailView: UIViewController {
    var viewModel: ExchangesDetailViewModel!

    var tableView: UITableView!

    var canncelables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
}

// MARK: Setup UI

extension ExchangesDetailView {
    private func setupUI() {
        setupNavigation()
        setupView()
        setupBindings()
    }

    private func setupView() {
        view.backgroundColor = .systemBackground

        tableView = UITableView(frame: view.bounds, style: .insetGrouped)
        tableView.allowsSelection = false
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }

    private func setupNavigation() {
        title = viewModel.title
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(markFavorite))
    }
}

// MARK: Setup Bindings

extension ExchangesDetailView {
    private func setupBindings() {
        viewModel.$data
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .store(in: &canncelables)

        viewModel.$isFavorite
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] value in
                self?.navigationItem.rightBarButtonItem?.image = value ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
            })
            .store(in: &canncelables)
    }

    @objc
    private func markFavorite() {
        viewModel.markAsFavorite.send()
    }
}

// MARK: Setup Tableview

extension ExchangesDetailView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in _: UITableView) -> Int {
        3
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return viewModel.data.count
        default:
            return 0
        }
    }

    func tableView(_: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Chart"
        case 1:
            return "Info"
        case 2:
            return "Rates"
        default:
            return ""
        }
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return UITableViewCell(style: .default, reuseIdentifier: "cellChart")
        case 1:
            return configureInfoCell()
        case 2:
            let data = viewModel.data[indexPath.row]
            return configureCell(data)
        default:
            return UITableViewCell(style: .default, reuseIdentifier: "empty")
        }
    }

    private func configureCell(_ data: Rate) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cellDetail")
        cell.textLabel?.text = Calendar.current.getStringFromDate(date: data.date)
        cell.detailTextLabel?.text = String(format: "%.3f", data.value)
        return cell
    }

    private func configureInfoCell() -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cellInfo")
        cell.textLabel?.text = "Base:"
        cell.detailTextLabel?.text = viewModel.base
        return cell
    }
}

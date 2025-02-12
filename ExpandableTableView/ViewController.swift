//
//  ViewController.swift
//  ExpandableTableView
//
//  Created by Shirish Koirala on 28/10/2024.
//

import UIKit

class ViewController: UIViewController {
    private var data: [ExpandableCellModel] = {
        (1...20).map {
            let longDescription = "This is a detailed description for item \($0). It provides more in-depth information about the cell, including features, usage, and additional insights that make this item unique and informative."
            let shortDescription = "Short description for item \($0)."
            let footerText = "Footer text for item \($0)."
            
            return ExpandableCellModel(
                heading: "Heading \($0)",
                title: "Title \($0)",
                description: $0 % 2 == 0 ? longDescription : shortDescription,
                footer: footerText,
                numbers: $0 % 2 == 0 ? Array(1...100).map{$0.description} : nil
            )
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ExpandibleCell.self, forCellReuseIdentifier: ExpandibleCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .background
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ExpandibleCell.identifier, for: indexPath) as! ExpandibleCell
        cell.configure(with: data[indexPath.row])
        cell.delegate = self
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ViewController: ExpandibleCellDelegate {
    func expandableTableViewCell(_ tableViewCell: UITableViewCell, expanded: Bool) {
        if let indexPath = tableView.indexPath(for: tableViewCell){
            data[indexPath.row].isExpanded = expanded
        }
    }
}

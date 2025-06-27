//
//  CollectionViewController.swift
//  TwentySixUIKit
//
//  Created by Zach Howe on 6/26/25.
//

import UIKit

@Observable
class CellViewModel {
    var text: String

    init(_ text: String = "") {
        self.text = text
    }
}

class Cell: UICollectionViewCell {

    var titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

enum CollectionCellState {
    case collapsed, expanded

    var height: CGFloat {
        switch self {
        case .collapsed:
            return 50
        case .expanded:
            return 200
        }
    }
}

@Observable
class CollectionViewModel {

    var cellState: CollectionCellState = .collapsed

    var cellViewModels: [CellViewModel] = [
        .init("😂"),
        .init("😏"),
        .init("😎"),
        .init("😩"),
        .init("🤖"),
        .init("😴"),
        .init("🙉"),
        .init("😽"),
        .init("😇"),
        .init("🥸"),
        .init("🤪"),
        .init("🦒"),
        .init("🦈"),
        .init("🦷"),
        .init("🍓"),
        .init("🛹"),
        .init("🚘"),
        .init("⌚️"),
        .init("🪰"),
        .init("🐸"),
        .init("🪴"),
        .init("🌽"),
        .init("🧇"),
        .init("🐥"),
        .init("🪼"),
    ]
}

class CollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var viewModel: CollectionViewModel

    lazy var collectionView =  {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()

    init(viewModel: CollectionViewModel = .init()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        title = "Collection View"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = collectionView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(Cell.self, forCellWithReuseIdentifier: "Cell")
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.cellViewModels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellViewModel = viewModel.cellViewModels[indexPath.item]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? Cell else {
            fatalError("Expected to be able to dequeue `Cell` subclass")
        }
        cell.contentView.backgroundColor = .systemGray6
        cell.configurationUpdateHandler = { [weak cell] _, state in
            cell?.titleLabel.text = cellViewModel.text
        }
        return cell
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let cellState = viewModel.cellState
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: collectionView.bounds.width, height: cellState.height)
        }

        if #available(iOS 26.0, *) {
            // no-op
        } else {
            updatePropertiesBody()
        }
    }

    @available(iOS 26.0, *)
    override func updateProperties() {
        super.updateProperties()

        updatePropertiesBody()
    }

    private func updatePropertiesBody() {
        let expandOrCollapseCellButton = viewModel.cellState == .collapsed
            ? UIBarButtonItem(title: "Expand", style: .plain, target: self, action: #selector(expandOrCollapseCells))
            : UIBarButtonItem(title: "Collapse", style: .plain, target: self, action: #selector(expandOrCollapseCells))

        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Update", style: .plain, target: self, action: #selector(updateCells)),
            expandOrCollapseCellButton,
        ]
    }

    @objc private func updateCells() {
        var i = 0
        for cellViewModel in viewModel.cellViewModels {
            cellViewModel.text += "\(i) "
            i += 1
        }
    }

    @objc private func expandOrCollapseCells() {
        if viewModel.cellState == .collapsed {
            viewModel.cellState = .expanded
        } else {
            viewModel.cellState = .collapsed
        }
    }
}

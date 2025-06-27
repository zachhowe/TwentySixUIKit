//
//  ViewController.swift
//  TwentySixUIKit
//
//  Created by Zach Howe on 6/26/25.
//

import UIKit

extension CounterViewController {
    @Observable
    class ViewModel {
        var count = 0
        var textColor: UIColor = .darkText
        var text: String = "Counter"
    }
}

class CounterViewController: UIViewController {

    let viewModel: ViewModel

    lazy var stackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    lazy var incrementButton = {
        let button = UIButton(type: .system)
        button.setTitle("Increment", for: .normal)
        return button
    }()

    lazy var decrementButton = {
        let button = UIButton(type: .system)
        button.setTitle("Decrement", for: .normal)
        return button
    }()

    lazy var label = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 36)
        return label
    }()

    init(viewModel: ViewModel = .init()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        title = "Counter"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(incrementButton)
        stackView.addArrangedSubview(decrementButton)
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        incrementButton.addTarget(self, action: #selector(onIncrementButtonAction), for: .primaryActionTriggered)
        decrementButton.addTarget(self, action: #selector(onDecrementButtonAction), for: .primaryActionTriggered)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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
        label.textColor = viewModel.textColor
        label.text = viewModel.text
        tabBarItem.badgeValue = "\(viewModel.count)"
    }

    @objc private func onIncrementButtonAction() {
        viewModel.count += 1
        viewModel.text = "\(viewModel.count)"
        viewModel.textColor = .green
    }

    @objc private func onDecrementButtonAction() {
        viewModel.count -= 1
        viewModel.text = "\(viewModel.count)"
        viewModel.textColor = .red
    }
}

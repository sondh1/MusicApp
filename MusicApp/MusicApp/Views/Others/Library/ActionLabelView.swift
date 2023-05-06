//
//  ActionLabelView.swift
//  MusicApp
//
//  Created by Đặng Hồng Sơn on 01/05/2023.
//

import UIKit
struct ActionLabelViewViewModel {
    let text: String
    let actionTitle: String
}

protocol ActionLabelViewDeleggate: AnyObject {
    func actionLabelViewDidTapButton(_ actionView: ActionLabelView)
}
class ActionLabelView: UIView {
    
    weak var delegate: ActionLabelViewDeleggate?
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let button: UIButton = {
       let button = UIButton()
        button.setTitleColor(.link, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        isHidden = true
        addSubview(button)
        addSubview(label)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    required init(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        button.frame = CGRect(x: 0, y: bounds.height-40, width: bounds.width, height: 40)
        label.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height-45)
    }
    
    func configure(with viewModel: ActionLabelViewViewModel) {
        label.text = viewModel.text
        button.setTitle(viewModel.actionTitle, for: .normal)
    }
    @objc func didTapButton() {
        delegate?.actionLabelViewDidTapButton(self)
    }
}

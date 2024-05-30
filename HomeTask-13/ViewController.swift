//
//  ViewController.swift
//  HomeTask-13
//
//  Created by Apple on 29.05.24.
//

import UIKit
import SnapKit
import Kingfisher
class ViewController: UIViewController {
    private let activityIndicator: UIActivityIndicatorView = {
        let av = UIActivityIndicatorView()
        av.hidesWhenStopped = true
        return av
    }()
    private let generalStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 12
        sv.alignment = .center
        return sv
    }()
    private let searchTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter username..."
        tf.layer.cornerRadius = 10
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.black.cgColor
        return tf
    }()
    private let searchButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Search", for: .normal)
        btn.backgroundColor = .systemPink
        btn.tintColor = .white
//        btn.addTarget(.none, action: #selector(dismissKeyboard), for: .touchUpInside)
        return btn
    }()
    
    private let avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 60
        return iv
    }()
    private let usernameLabel: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 20, weight: .bold)
        return lb
    }()
    private let bioLabel: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 14)
        lb.numberOfLines = 0
        lb.textAlignment = .center
        return lb
    }()
    private let activityStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .equalSpacing
        sv.spacing = 12
        return sv
    }()
    private let followersLabel: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 14, weight: .semibold)
        return lb
    }()
    private let followingLabel: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 14, weight: .semibold)
        return lb
    }()
    private let publicRepoLabel: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 14, weight: .semibold)
        return lb
    }()
    private let emptyView: UIView = {
        let view = UIView()
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(generalStackView)
        [
            searchTextField,
            searchButton,
            avatarImageView,
            usernameLabel,
            bioLabel,
            activityStackView,
            emptyView
        ].forEach(generalStackView.addArrangedSubview)
        [
            followersLabel,
            followingLabel,
            publicRepoLabel
        ].forEach(activityStackView.addArrangedSubview)
        generalStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        avatarImageView.snp.makeConstraints { make in
            make.width.equalTo(120)
            make.height.equalTo(120)
        }
        searchTextField.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.width.equalTo(UIScreen.main.bounds.width-16)
        }
        searchButton.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.width.equalTo(UIScreen.main.bounds.width-16)
        }
        emptyView.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width)
            make.height.equalTo(300)
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        searchButton.addGestureRecognizer(tapGesture)
        searchTextField.addTarget(self, action: #selector(didChangeSearchField), for: .editingChanged)
        searchTextField.delegate = self
    }
    @objc
    private func didChangeSearchField() {
        print(searchTextField.text ?? "")
    }
    @objc
    private func dismissKeyboard(){
        view.endEditing(true)
    }
}
extension ViewController: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        activityIndicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
            NetworkManager.shared.getUser(username: textField.text ?? "") { [weak self] result in
                defer {
                    self?.activityIndicator.stopAnimating()
                }
                switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        self?.avatarImageView.kf.setImage(with: URL(string: data.avatar_url))
                        self?.usernameLabel.text = data.name
                        self?.bioLabel.text = data.bio
                        self?.followersLabel.text = "\(data.followers) followers"
                        self?.followingLabel.text = "\(data.following) following"
                        self?.publicRepoLabel.text = "\(data.public_repos) public repository"
                    }
                case .failure(let error):
                    print(error)
                }
    
            }
        }
    }
}


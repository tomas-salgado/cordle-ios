//
//  KeyboardViewController.swift
//  cordle
//
//  Created by Tomas on 4/28/23.
//

import UIKit

protocol KeyBoardViewControllerDelegate: AnyObject {
    func keyboardViewController(
        _ vc: KeyboardViewController,
        didTapKey letter: Character
    )
}

class KeyboardViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    weak var delegate: KeyBoardViewControllerDelegate?
    
    let letters = ["qwertyuiop", "asdfghjkl", "zxcvbnm👈"]
    private var keys: [[Character]] = []
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 2
        let keyboardCV = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        keyboardCV.translatesAutoresizingMaskIntoConstraints = false
        keyboardCV.backgroundColor = .clear
        keyboardCV.register(KeyCell.self, forCellWithReuseIdentifier: KeyCell.identifier)
        
        return keyboardCV
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
        
        for row in letters {
            let chars = Array(row)
            keys.append(chars)
        }
        
        setUpConstraints()
    }
    
    func setUpConstraints(){
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

}

extension KeyboardViewController{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return keys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keys[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KeyCell.identifier, for: indexPath) as? KeyCell else {
            fatalError()
        }
        let letter = keys[indexPath.section][indexPath.row]
        cell.configure(with: letter)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let margin: CGFloat = 20
        let size: CGFloat = (collectionView.frame.size.width-margin)/10
        
        return CGSize(width: size, height: size*1.5)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        var left: CGFloat = 1
        var right: CGFloat = 1
        
        let margin: CGFloat = 20
        let size: CGFloat =
        (collectionView.frame.size.width - margin)/10
        
        let count : CGFloat =
            CGFloat(collectionView.numberOfItems(inSection: section))
        
        let inset: CGFloat = (collectionView.frame.size.width - (size * count) - 2 * count)/2
        
        left = inset
        right = inset
        
        
        return UIEdgeInsets(
            top: 2,
            left: left,
            bottom: 2,
            right: right)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        let letter = keys[indexPath.section][indexPath.row]
        delegate?.keyboardViewController(self, didTapKey: letter)
    }
}

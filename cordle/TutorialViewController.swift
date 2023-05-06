//
//  TutorialViewController.swift
//  cordle
//
//  Created by Tomas on 4/30/23.
//

import UIKit

class TutorialViewController: UIViewController{
    
    let playLabel = UILabel()
    let rulesLabel = UILabel()
    let lgr = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black

        playLabel.textColor = .white
        playLabel.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        playLabel.text = "How to Play Cordle"
        playLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(playLabel)
       
        rulesLabel.textColor = .white
        rulesLabel.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        rulesLabel.numberOfLines = 0
        rulesLabel.text = "\n1) For each guess, enter a five-letter word (think of Cornell-themed words!)\n \n \n2) The color of the tiles will change to show how close your guess was \n \n \n3) If a tile turns orange, this means you have the right letter, but in the wrong position \n \n \n4) If a tile turns green, you have the right letter in the right position! \n \n \n5) Keep guessing until you get the word!"
        rulesLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(rulesLabel)
        
        lgr.textColor = .red
        lgr.font = UIFont.systemFont(ofSize: 30, weight: .regular)
        lgr.text = "🐻 LET'S GO RED! 🐻"
        lgr.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lgr)
        
        setUpConstraints()
        
    }
    
    func setUpConstraints() {
        
        NSLayoutConstraint.activate([
            playLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            playLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30)
        ])
        
        NSLayoutConstraint.activate([
            rulesLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            rulesLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            rulesLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            rulesLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            lgr.topAnchor.constraint(equalTo: rulesLabel.bottomAnchor, constant: -30),
            lgr.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            lgr.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}


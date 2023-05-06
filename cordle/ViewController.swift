//
//  ViewController.swift
//  cordle
//
//  Created by Tomas on 4/28/23.
//

import UIKit
import Alamofire
import SwiftyJSON


var answer = ""

var answer_len = 0

class ViewController: UIViewController {
    
    let game_title = UILabel()
    let tutorial = UIButton()
    
    //will get all possible answers from backend
    var answers = [
        "hotel", "dyson", "slope", "ctown", "netid"
    ]

    
    private var guesses: [[Character?]] = Array(
        repeating: Array(repeating: nil, count: 5),
        count: 6
    )

    let keyboardVC = KeyboardViewController()
    let boardVC = BoardViewController()
    let json = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        struct Puzzle: Decodable {
            enum Category: String, Decodable {
                case swift, combine, debugging, xcode
            }

            let hint: String
            let id: Int
            let word: String
        }
        
        let endpoint = "http://34.86.231.38/"
    
        AF.request(endpoint).responseJSON {[self] response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                //print(json)
                // use the parsed JSON object here
                let puzzles = json["puzzles"].arrayValue
                for puzzle in puzzles {
                    let id = puzzle["id"].intValue
                    let word = puzzle["word"].string
                    self.answers.append(word!)
                    let words = self.answers
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        answer = answers.randomElement() ?? "dyson"
        answer_len = answer.count
        guesses = Array(repeating: Array(repeating: nil, count: answer_len), count: 5)
        
        view.backgroundColor = .black
        addChildren()
        
        game_title.text = "CORDLE 🐻"
        game_title.textColor = .red
        game_title.textAlignment = .center
        game_title.font = UIFont(name: "ArialRoundedMTBold", size: 40)
        game_title.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(game_title)
        
        let insets = UIEdgeInsets(top: 12.0, left: 20.0, bottom: 22.0, right: 12.0)
        let image = UIImage(named: "tutorial")
        image?.resizableImage(withCapInsets: insets, resizingMode: .stretch)
        tutorial.setImage(UIImage(named: "tutorial"), for: .normal)
        tutorial.layer.cornerRadius = 5
        tutorial.clipsToBounds = true
        tutorial.translatesAutoresizingMaskIntoConstraints = false
        tutorial.addTarget(self, action: #selector(pushView), for: .touchUpInside)
        view.addSubview(tutorial)
        
        setUpConstraints()
        
        
    }
    
    private func addChildren(){
        addChild(keyboardVC)
        keyboardVC.didMove(toParent: self)
        keyboardVC.delegate = self
        keyboardVC.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(keyboardVC.view)
        
        addChild(boardVC)
        boardVC.didMove(toParent: self)
        boardVC.view.translatesAutoresizingMaskIntoConstraints = false
        boardVC.datasource = self
        view.addSubview(boardVC.view)
    }
    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            keyboardVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            keyboardVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            keyboardVC.view.topAnchor.constraint(equalTo: boardVC.view.bottomAnchor),
            keyboardVC.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            boardVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            boardVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            boardVC.view.topAnchor.constraint(equalTo: game_title.bottomAnchor),
            boardVC.view.bottomAnchor.constraint(equalTo: keyboardVC.view.topAnchor),
            boardVC.view.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6)
        ])
        
        NSLayoutConstraint.activate([
            game_title.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            game_title.heightAnchor.constraint(equalToConstant: 50),
            game_title.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            game_title.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            tutorial.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            tutorial.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -23),
            tutorial.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -5),
            tutorial.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 23)
            
            
        ])
    }
    
    @objc func pushView(){
        //push TutorialVC
        present(TutorialViewController(), animated: true)
    }

}

var keyboardActive = true

extension ViewController: KeyBoardViewControllerDelegate{
    func keyboardViewController(_ vc: KeyboardViewController, didTapKey letter: Character) {
        // update guesses
        
        var backStop = false
        
        if (letter == "👈"){
            for i in 0..<guesses.count {
                for j in 0..<guesses[i].count{
                    if guesses[i][j] == nil {
                        if j != 0 {
                            guesses[i][j-1] = nil
                            backStop = true
                            break
                        }
                    }
                }
                if backStop {
                    break
                }
            }
        }
        
        else {
            var stop = false
            
            for i in 0..<guesses.count {
                for j in 0..<guesses[i].count{
                    if guesses[i][j] == nil {
                        guesses[i][j] = letter
                        stop = true
                        break
                    }
                    if !keyboardActive {
                        stop = true
                        break
                    }
                    
                }
                
                if stop {
                    break
                }
            }
        }
        
        boardVC.reloadData()
    }
}


extension ViewController: BoardViewControllerDatasource {
    var currentGuesses: [[Character?]] {
        return guesses
    }
    
    func boxColor(at indexPath: IndexPath) -> UIColor? {
        let rowIndex = indexPath.section
        
        let count = guesses[rowIndex].compactMap({ $0 }).count
        guard count == 5 else {
            return nil
        }
        
        let indexedAnswer  = Array(answer)
        
        guard let letter = guesses[indexPath.section][indexPath.row], indexedAnswer.contains(letter) else {
            return nil
        }
        
//      freeeze user input (so they can't enter any more letters)
        if guesses[indexPath.section] == indexedAnswer {
            keyboardActive = false
            return .systemGreen
        }
        
        if indexedAnswer[indexPath.row] == letter {
            return .systemGreen
        }
        
        return .systemOrange
                
    }
    
    
}

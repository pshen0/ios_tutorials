//
//  ViewController.swift
//  ButtonDemo
//
//  Created by Анна Сазонова on 30.06.2025.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var counterLabelOutlet: UILabel!
    
    var count = 0
    var isYellow = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        counterLabelOutlet.text = "Счет: 0"
        view.backgroundColor = .systemYellow
    }
    
    
    @IBAction func showMessage(_ sender: UIButton) {
        let alert = UIAlertController(title: "Привет!", message: "Ты нажал на кнопку", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default))
        present(alert, animated: true)
    }
    
    
    @IBAction func changeBackground(_ sender: UIButton) {
        view.backgroundColor = isYellow ?  .systemPink : .systemYellow
        isYellow.toggle()
    }
    
    @IBAction func incrementCounter(_ sender: UIButton) {
        count += 1
        counterLabelOutlet.text = "Счёт: \(count)"
    }
    
    
}


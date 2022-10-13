//
//  ViewController.swift
//  githubAPI
//
//  Created by Vinicius on 04/10/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var userInputTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func showUser(_ sender: Any) {
        performSegue(withIdentifier: "DetailController", sender: self)
        userInputTF.text = ""
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailController" {
            if let destination = segue.destination as? DetailViewController {
                destination.gitUser = userInputTF.text ?? ""
            }
        }
    }
    
}


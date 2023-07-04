//
//  ViewControllerB.swift
//  iOSFinal
//
//  Created by QuanDL.FA on 2/1/23.
//

import UIKit
protocol WeatherDelegate {
    func searchCity(name: String)
    func check(tag: Int)
}
class ViewControllerB: UIViewController {

    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searching: UITextField!
    var delegate: WeatherDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func finding(_ sender: UIButton) {
        print(sender.tag)
        guard let data = searching.text else {return}
        self.delegate?.searchCity(name: data)
        self.delegate?.check(tag: sender.tag)
        self.navigationController?.popViewController(animated: true)
    }
    


}

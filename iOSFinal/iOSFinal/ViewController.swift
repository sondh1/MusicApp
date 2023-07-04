//
//  ViewController.swift
//  iOSFinal
//
//  Created by QuanDL.FA on 1/31/23.
//

import UIKit
import SDWebImage
class ViewController: UIViewController{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var label34: UILabel!
    @IBOutlet weak var label32: UILabel!
    @IBOutlet weak var label31: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var label26: UILabel!
    @IBOutlet weak var label25: UILabel!
    @IBOutlet weak var label24: UILabel!
    @IBOutlet weak var label23: UILabel!
    @IBOutlet weak var label22: UILabel!
    var data: Weather?
    var name = "Berlin"
    var clicked: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ViewControllerB {
            vc.delegate = self
        }
        clicked = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if clicked != nil && name != "" {
            setupData()
        }

    
    }
    func setupData() {
        NetworkManager.shared.getData(name: name) { weather in
            self.data = weather
            if let temp = weather.current?.temp_c {
                self.label22.text = "Temp: \(temp) ℃"
                self.label34.text = "\(temp) ℃"
            }
            if let temp = weather.forecast?.forecastday?[0].day?.mintemp_c {
                self.label23.text = "TempMin: \(temp) ℃"
            }
            if let temp = weather.forecast?.forecastday?[0].day?.maxtemp_c {
                self.label24.text = "TempMax: \(temp) ℃"
            }
            if let temp = weather.current?.pressure_mb {
                self.label25.text = "Pressure: \(temp) "
            }
            if let temp = weather.current?.humidity {
                self.label26.text = "Humidity: \(temp) "
            }
            if let temp = weather.location?.name {
                self.label31.text = temp
                self.label31.font = UIFont.boldSystemFont(ofSize: 20)
            }
            if let temp = weather.current?.condition?.text {
                self.label32.text = temp
            }
            if let temp = weather.current?.condition?.icon {
                self.img.sd_setImage(with: URL(string: "https:\(temp)"))
            }
            DispatchQueue.main.async { [self] in
                self.tableView.reloadData()
                
            }
        }
    }
    func setupView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TableViewCell.self)
    }



}
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data = data {
            return data.forecast?.forecastday?[0].hour?.count ?? 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        
            let status = data?.forecast?.forecastday?[0].hour?[indexPath.row].condition?.text ?? ""
            let temp = String(data?.forecast?.forecastday?[0].hour?[indexPath.row].temp_c ?? 0.0)
            let time = data?.forecast?.forecastday?[0].hour?[indexPath.row].time ?? ""
            let icon = data?.forecast?.forecastday?[0].hour?[indexPath.row].condition?.icon ?? ""
            cell.setupCell(label1: status, label2: time, label3: temp, img1: icon)
        return cell
    }
    
    
}
extension ViewController: WeatherDelegate {
    func check(tag: Int) {
        self.clicked = tag
    }
    
    func searchCity(name: String) {
        self.name = name
    }
}
extension UITableView {

    func register<T: UITableViewCell>(_ aClass: T.Type, bundle: Bundle? = .main) {

        let name = String(describing: aClass)

        if bundle?.path(forResource: name, ofType: "nib") != nil {

            let nib = UINib(nibName: name, bundle: bundle)

            register(nib, forCellReuseIdentifier: name)

        } else {

            register(aClass, forCellReuseIdentifier: name)

        }

    }

}

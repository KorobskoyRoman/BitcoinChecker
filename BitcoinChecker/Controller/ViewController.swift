//
//  ViewController.swift
//  BitcoinChecker
//
//  Created by Roman Korobskoy on 20.12.2021.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet var bitcoinLabel: UILabel!
    @IBOutlet var currencyLabel: UILabel!
    @IBOutlet var currencyPicker: UIPickerView!
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var stackView: UIStackView!
    
    var coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stackView.isHidden = true
        setupDelegate()
    }
    
    private func setupDelegate() {
        coinManager.delegate = self
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
    }

}

// MARK: UIPickerViewDataSource

extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { //возвращаем кол-во данных из массива
        return coinManager.currencyArray.count
    }
}

// MARK: UIPickerViewDelegate

extension ViewController: UIPickerViewDelegate { //настраиваем соответствие строк нашему массиву
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCurrency = coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: selectedCurrency)
    }
}

// MARK: CoinManagerDelegate

extension ViewController: CoinManagerDelegate {
    func updateCurrency(price: String, currency: String) {
        DispatchQueue.main.async {
            
            self.bitcoinLabel.text = price
            self.currencyLabel.text = currency
            self.infoLabel.isHidden = true
            self.stackView.isHidden = false
        }
    }
    
    func didFailWithError(error: Error) {
        print(error.localizedDescription)
    }
}

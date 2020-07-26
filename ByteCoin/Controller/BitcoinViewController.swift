//
//  ViewController.swift
//  ByteCoin
//
//  Created by Artem Tkachuk on 7/25/20.
//  Copyright © 2020 Artem Tkachuk. All rights reserved.
//

import UIKit

//MARK: - Outlets and Actions
class BitcoinViewController: UIViewController {
    
    @IBOutlet weak var coinPriceLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    var coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set delegates
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        coinManager.delegate = self
        
        let defaultCurrency = "USD"
        showDefaultCurrencyRate(defaultCurrency)
    }
}


//MARK: - UIPickerViewDataSource
extension BitcoinViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
}


//MARK: - UIPickerViewDelegate
extension BitcoinViewController: UIPickerViewDelegate {
    //component == column
    //this method is called for every single rown when the UIPickerView is trying to load up
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCurrency = coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: selectedCurrency)
    }
}

//MARK: - CoinManagerDelegate
extension BitcoinViewController: CoinManagerDelegate {
    func didReceiveCoinPrice(_ CoinManager: CoinManager, _ price: Double, _ currency: String) {
        DispatchQueue.main.async {
            self.coinPriceLabel.text = String(format: "%.2f", price)
            self.currencyLabel.text = currency
        }
    }
    
    func didFailWithError(_ CoinManager: CoinManager, _ error: Error) {
        DispatchQueue.main.async {
            let message = "The rate cannot be obtained at this point :(\nPlease try another currency"
            // create the alert
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showDefaultCurrencyRate(_ defaultCurrency: String) {
        //Show current price in a selectedCurrency by default
        coinManager.getCoinPrice(for: defaultCurrency)
        let indexOfDefaultCurrency = coinManager.currencyArray.firstIndex(of: defaultCurrency)!
        currencyPicker.selectRow(indexOfDefaultCurrency, inComponent: 0, animated: true)
    }
}

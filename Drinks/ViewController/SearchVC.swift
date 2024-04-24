//
//  SearchVC.swift
//  Drinks
//
//  Created by M Usman on 24/04/2024.
//

import UIKit



class SearchVC: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var nameBtn:UIButton!
    @IBOutlet weak var firstAlhpabetBtn:UIButton!
    @IBOutlet weak var searchTxt:UITextField!
    
    // MARK: - Variables and Constant
    var isSearchByAlphabet = false
    var delegate : SearchProtocol?
    
    //MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isSearchByAlphabet = UserDefaultManager.shared.getIsSearchByAlphabet()
        updateOptionButtonUI()
        searchTxt.delegate=self
    }
    
    
    // MARK: - IBActions
    @IBAction func changeOptionBtn(_ sender: UIButton){
        if sender.tag == 0 {
            self.isSearchByAlphabet = false
        }else{
            self.isSearchByAlphabet = true
        }
        searchTxt.text = ""
        updateOptionButtonUI()
    }
    @IBAction func searchBtnTap(_ sender: UIButton){
        if let searchText = searchTxt.text?.trimmingCharacters(in: .whitespacesAndNewlines) , searchText != "" {
            UserDefaultManager.shared.savelastSearchType(isSearchByAlphabet: self.isSearchByAlphabet)
            delegate?.searchString(text: searchText)
            self.dismiss(animated: true)
        }
    }
    // MARK: - Helper Methods
    
    
    // MARK: - #Selectors
    
    // MARK: - User Methods
    func updateOptionButtonUI(){
        nameBtn.backgroundColor = .appSecondary
        nameBtn.setTitleColor(.appPrimary, for: .normal)
        firstAlhpabetBtn.backgroundColor = .appSecondary
        firstAlhpabetBtn.setTitleColor(.appPrimary, for: .normal)
        if isSearchByAlphabet{
            firstAlhpabetBtn.backgroundColor = .appPrimary
            firstAlhpabetBtn.setTitleColor(.white, for: .normal)
        }else{
            nameBtn.backgroundColor = .appPrimary
            nameBtn.setTitleColor(.white, for: .normal)
        }
    }
    

}


extension SearchVC : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if isSearchByAlphabet, let text = textField.text,
           let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange,with: string)
            if updatedText.count > 1 {
                return false
            }
        }
        return true
    }
}

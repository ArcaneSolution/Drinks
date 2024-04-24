//
//  FavoriteVC.swift
//  Drinks
//
//  Created by M Usman on 24/04/2024.
//

import UIKit
import Combine

class FavoriteVC: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var tableView:UITableView!
    
    // MARK: - Variables and Constant
    var bindings = Set<AnyCancellable>()
    var viewModel = FavoriteViewModel()
    
    
    //MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "RecipeTableCell", bundle: nil), forCellReuseIdentifier: "RecipeTableCell")
        tableView.dataSource=self
        tableView.delegate=self
        setUpBindings()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getFavorite()
    }
    
    
    // MARK: - IBActions
    
    
    // MARK: - Helper Methods
    @objc func removeFromFavorites(_ sender:UIButton){
        viewModel.removeFromFavorite(index: sender.tag)
    }
    
    // MARK: - #Selectors
    
    // MARK: - User Methods
    private func setUpBindings(){
        func bindViewToViewModel() {
        }
        func bindViewModelToView(){
            viewModel.$drinks
                .sink { _ in
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }.store(in: &bindings)
        }
        bindViewModelToView()
        bindViewToViewModel()
    }

}


extension FavoriteVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.drinks.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeTableCell", for: indexPath) as? RecipeTableCell else {return UITableViewCell()}
        cell.assignFavoriteToUI(recipe: viewModel.drinks[indexPath.row])
        cell.fvrtBtn.tag = indexPath.row
        cell.fvrtBtn.addTarget(self, action: #selector(removeFromFavorites(_:)), for: .touchUpInside)
        return cell
    }
}

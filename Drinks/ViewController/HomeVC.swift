//
//  HomeVC.swift
//  Drinks
//
//  Created by M Usman on 24/04/2024.
//

import UIKit
import Combine

class HomeVC: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var activityIndicator:UIActivityIndicatorView!
    
    // MARK: - Variables and Constant
    
    var bindings = Set<AnyCancellable>()
    var viewModel = HomeViewModel()
    
    var updatingIndex = -1
    
    //MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationManager.shared.removeAllNotifications()
        DispatchQueue.main.asyncAfter(deadline: .now()+1){
            NotificationManager.shared.handleNotification()
        }
        tableView.register(UINib(nibName: "RecipeTableCell", bundle: nil), forCellReuseIdentifier: "RecipeTableCell")
        tableView.dataSource=self
        tableView.delegate=self
        setUpBindings()
        viewModel.initialRecipeFetch()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    
    // MARK: - IBActions
    @IBAction func searchBtnTap(_ sender: UIButton){
        if let vc = AppConstant.mainStoryBoard.instantiateViewController(withIdentifier: "SearchVC") as? SearchVC {
            vc.delegate = self
            self.present(vc, animated: true)
        }
    }
    
    // MARK: - Helper Methods
    
    
    // MARK: - #Selectors
    @objc func addToFavorite(_ sender:UIButton){
        updatingIndex = sender.tag
        if let cell = self.tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as? RecipeTableCell {
            viewModel.addToFavorite(index: sender.tag, image: cell.recipeImage.image)
        }
    }
    
    // MARK: - User Methods
    private func setUpBindings(){
        func bindViewToViewModel() {
        }
        func bindViewModelToView(){
            viewModel.$drinks
                .receive(on: DispatchQueue.main)
                .sink { drinks in
//                    DispatchQueue.main.async {
                        self.tableView.reloadData()
//                    }
                }.store(in: &bindings)
            viewModel.favoriteStatusUpdate
                .sink { _ in
                    DispatchQueue.main.async {
                        self.tableView.reloadRows(at: [IndexPath(row: self.updatingIndex, section: 0)], with: .automatic)
                        self.updatingIndex = -1
                    }
                }.store(in: &bindings)
            viewModel.$isLoading
                .receive(on: DispatchQueue.main)
                .sink { isLoading in
                    self.activityIndicator.isHidden = !isLoading
                    isLoading ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
                }.store(in: &bindings)
        }
        bindViewModelToView()
        bindViewToViewModel()
    }
}


extension HomeVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.drinks.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeTableCell", for: indexPath) as? RecipeTableCell else {return UITableViewCell()}
        cell.assignDatatoUI(recipe: viewModel.drinks[indexPath.row])
        cell.fvrtBtn.tag = indexPath.row
        cell.fvrtBtn.addTarget(self, action: #selector(addToFavorite(_:)), for: .touchUpInside)
        return cell
    }
}


extension HomeVC : SearchProtocol {
    func searchString(text: String) {
        viewModel.drinks.removeAll()
        viewModel.fetchRecipesby(text: text)
    }
}

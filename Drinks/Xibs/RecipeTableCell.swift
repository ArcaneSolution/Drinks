//
//  RecipeTableCell.swift
//  Drinks
//
//  Created by M Usman on 23/04/2024.
//

import UIKit

class RecipeTableCell: UITableViewCell {
    
    @IBOutlet weak var bgView:UIView!
    @IBOutlet weak var recipeImage:UIImageView!
    @IBOutlet weak var nameLbl:UILabel!
    @IBOutlet weak var categoryLbl:UILabel!
    @IBOutlet weak var alcoholicLbl:UILabel!
    @IBOutlet weak var fvrtBtn:UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bgView.setViewCard()
        recipeImage.roundView(with: recipeImage.bounds.height/2)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    override func prepareForReuse() {
        recipeImage.image = nil
        fvrtBtn.setImage(.starEmpty, for: .normal)
    }
    
    func assignDatatoUI(recipe:Drinks){
        recipeImage.setImage(fromURLString: recipe.strDrinkThumb ?? "")
        nameLbl.text = recipe.strDrink
        categoryLbl.text = recipe.strCategory
        alcoholicLbl.text = recipe.strAlcoholic
        alcoholicLbl.textColor = (recipe.strAlcoholic == "Alcoholic") ? .customRed : .customGreen
        fvrtBtn.setImage(.starEmpty, for: .normal)
        if DBManager.shared.checkIsFavoriteExist(byID: recipe.idDrink ?? "-1") {
            fvrtBtn.setImage(.starFilled, for: .normal)
        }
    }
    func assignFavoriteToUI(recipe:FavoriteModel){
        recipeImage.image = FileHandler.shared.getImage(withName: recipe.image)
        nameLbl.text = recipe.name
        categoryLbl.text = recipe.category
        alcoholicLbl.text = recipe.alcoholic
        alcoholicLbl.textColor = (recipe.alcoholic == "Alcoholic") ? .customRed : .customGreen
        fvrtBtn.setImage(.starFilled, for: .normal)
    }
    
}

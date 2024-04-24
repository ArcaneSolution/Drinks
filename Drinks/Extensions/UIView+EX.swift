//
//  UIView+EX.swift
//  Drinks
//
//  Created by M Usman on 23/04/2024.
//

import UIKit


extension UIView {
    func setViewCard(_ cornerRadius: CGFloat = 10, _ shadowColor: CGColor = UIColor.shadow.cgColor , shadowWidth:CGFloat=2.0 , shadowHeight:CGFloat=5.0, borderColor: UIColor = .clear, borderSize: CGFloat = 0, shadowRadius: CGFloat = 2.0,offset: CGSize = CGSize(width: 0, height: 0)) {
        self.layer.masksToBounds = false
        self.layer.shadowColor =  shadowColor
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = 1
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderSize
        self.layer.cornerRadius = cornerRadius
    }
    func roundView(with radius:CGFloat = 10,_ borderColor: UIColor = .clear, _ borderSize: CGFloat = 0){
        self.layer.cornerRadius = radius
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderSize
        self.clipsToBounds = true
    }
}

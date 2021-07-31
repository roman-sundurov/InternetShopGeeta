//
//  VCProfileSlider.swift
//  Skillbox_diploma_step2
//
//  Created by Roman on 23.07.2021.
//

import UIKit


class VCProfileSlider: UIViewController {
    
    
    //MARK: - объявление аутлетов
    
    @IBOutlet var firstViewProfileSlider: UIView!
    @IBOutlet var accountImage: UIImageView!
    
    
    //MARK: - делегаты и переменные
    
    //MARK: - объекты
    
    //MARK: - переходы
    
    //MARK: - клики
    
    //MARK: - данные

    //MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstViewProfileSlider.backgroundColor = .white
        
        let layer0 = CAGradientLayer()
        layer0.colors = [
          UIColor(red: 0.5, green: 0.468, blue: 0.996, alpha: 1).cgColor,
          UIColor(red: 0.647, green: 0.451, blue: 1, alpha: 1).cgColor
        ]
        layer0.locations = [0, 1]
        layer0.startPoint = CGPoint(x: 0.25, y: 0.5)
        layer0.endPoint = CGPoint(x: 0.75, y: 0.5)
        layer0.bounds = firstViewProfileSlider.bounds
        layer0.position = firstViewProfileSlider.center
        firstViewProfileSlider.layer.addSublayer(layer0)
        
        
        accountImage.layer.cornerRadius = 30
        accountImage.clipsToBounds = true
        accountImage.backgroundColor = .white

        
        
    }
    
    //MARK: - additional protocols


}

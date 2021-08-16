//
//  VCProfileSlider.swift
//  Skillbox_diploma_step2
//
//  Created by Roman on 23.07.2021.
//

import UIKit


class VCProfileSlider: UIViewController {
    
    
    //MARK: - объявление аутлетов
    
    @IBOutlet var accountImage: UIImageView!
    
    
    
    //MARK: - делегаты и переменные
    
    //MARK: - объекты
    
    //MARK: - переходы
    
    //MARK: - клики
    
    //MARK: - данные

    //MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        accountImage.layer.cornerRadius = 30
        accountImage.layer.borderWidth = 3
        accountImage.layer.borderColor = UIColor.white.cgColor
        accountImage.clipsToBounds = true
        accountImage.backgroundColor = .white
        
    }
    
    //MARK: - additional protocols


}

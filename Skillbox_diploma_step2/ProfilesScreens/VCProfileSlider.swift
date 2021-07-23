//
//  VCProfileSlider.swift
//  Skillbox_diploma_step2
//
//  Created by Roman on 23.07.2021.
//

import UIKit

@IBDesignable class VCProfileSlider: UIViewController {
    
    
    //MARK: - объявление аутлетов
    
    @IBOutlet var firstViewProfileSlider: UIView!
    
    
    //MARK: - делегаты и переменные
    
    //MARK: - объекты
    
    //MARK: - переходы
    
    //MARK: - клики
    
    //MARK: - данные
    
    //MARK: - viewDidLoad
    
    //MARK: - additional protocols
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 295).isActive = true
        view.heightAnchor.constraint(equalToConstant: 875).isActive = true
        view.leadingAnchor.constraint(equalTo: firstViewProfileSlider.leadingAnchor, constant: 119).isActive = true
        view.topAnchor.constraint(equalTo: firstViewProfileSlider.topAnchor, constant: 0).isActive = true
        
        
        view.frame = CGRect(x: 0, y: 0, width: 295, height: 875)
        view.backgroundColor = .white
        let layer0 = CAGradientLayer()
        layer0.colors = [
          UIColor(red: 0.5, green: 0.468, blue: 0.996, alpha: 1).cgColor,
          UIColor(red: 0.647, green: 0.451, blue: 1, alpha: 1).cgColor
        ]
        layer0.locations = [0, 1]
        layer0.startPoint = CGPoint(x: 0.25, y: 0.5)
        layer0.endPoint = CGPoint(x: 0.75, y: 0.5)
        layer0.bounds = view.bounds
//        layer0.bounds = view.bounds.insetBy(dx: -0.5*view.bounds.size.width, dy: -0.5*view.bounds.size.height)
        layer0.position = view.center
        view.layer.addSublayer(layer0)
        firstViewProfileSlider.addSubview(view)
//        firstViewProfileSlider.clipsToBounds = true

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

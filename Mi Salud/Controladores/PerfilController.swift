//
//  PerfilController.swift
//  Mi Salud
//
//  Created by ITMED on 9/8/18.
//  Copyright © 2018 ITMED. All rights reserved.
//

import UIKit

class PerfilController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Atras"
        navigationItem.backBarButtonItem = backItem
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }

    @IBAction func evento_cerrar_sesion(_ sender: UIBarButtonItem) {
        let refreshAlert = UIAlertController(title: "Confirmación", message: "¿Deseas finalizar la sesión?", preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Si", style: .default, handler: { (action: UIAlertAction!) in
            UsuariosEntity.shared.deleteUsuarios()
            let storyBoard : UIStoryboard = UIStoryboard(name: "IniciarSesion", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier : "IniciarSesionController") as! IniciarSesionController
            self.present(newViewController, animated: true, completion: nil)
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        present(refreshAlert, animated: true, completion: nil)
    }
    
    
}

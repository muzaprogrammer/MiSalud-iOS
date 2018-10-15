//
//  DetallesDocumentoController.swift
//  Mi Salud
//
//  Created by ITMED on 10/8/18.
//  Copyright © 2018 ITMED. All rights reserved.
//

import UIKit

class DetallesDocumentoController: UIViewController, UIWebViewDelegate {
    
    let URLs : Uris = Uris()
    
    var idDocumento : Int = 0;
    var idExpediente : Int = 0;
    
    @IBOutlet weak var WebViewDetalleDocumento: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false

        WebViewDetalleDocumento.delegate = self
        if let url = URL(string: URLs.url_obtener_documentos_internos_detalles(idExpediente: idExpediente, idDocumento: idDocumento)) {
            let request = URLRequest(url: url)
            WebViewDetalleDocumento.loadRequest(request)
        }
    }
    
}

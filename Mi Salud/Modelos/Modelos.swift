//
//  Modelos.swift
//  MiSalud-iOS
//
//  Created by ITMED, Ricardo Alcides Castillo Rogel on 29/6/18.
//  Copyright © 2018 ITMED. All rights reserved.
//

import Foundation
import SQLite

class UsuariosEntity{
    
    static let shared = UsuariosEntity()
    
    private let tblUsuarios = Table("tblUsuarios")
    private let idExpediente = Expression<Int>("idExpediente")
    private let nombreCompleto = Expression<String>("nombreCompleto")
    private let idAsignacionMembresia = Expression<Int>("idAsignacionMembresia")
    private let correoElectronico = Expression<String>("correoElectronico")
    private let contrasenia = Expression<String>("contrasenia")
    
    private init(){
        //Create table if not exists
        do{
            if let connection = Database.shared.connection{
                try connection.run(tblUsuarios.create(temporary : false, ifNotExists : true, withoutRowid : false, block: { (table) in
                    table.column(self.idExpediente)
                    table.column(self.nombreCompleto)
                    table.column(self.idAsignacionMembresia)
                    table.column(self.correoElectronico)
                    table.column(self.contrasenia)
                }))
            }
        }catch{
            
        }
    }
    
    func insert(idExpediente : Int, nombreCompleto : String, idAsignacionMembresia : Int, correoElectronico : String, contrasenia : String) -> Int64? {
        do{
            let insert = tblUsuarios.insert(self.idExpediente <- idExpediente,
                                            self.nombreCompleto <- nombreCompleto,
                                            self.idAsignacionMembresia <- idAsignacionMembresia,
                                            self.correoElectronico <- correoElectronico,
                                            self.contrasenia <- contrasenia)
            let insertId = try Database.shared.connection!.run(insert)
            return insertId
        }catch{
            let nserror = error as NSError
            print("cannot insert new usuario, Error in : \(nserror), \(nserror.userInfo)")
            return nil
        }
    }
    
    func queryAll() -> AnySequence<Row>?{
        do{
            return try Database.shared.connection?.prepare(self.tblUsuarios)
        }catch{
            let nserror = error as NSError
            print("cannot query all usuarios, Error in : \(nserror), \(nserror.userInfo)")
            return nil
            
        }
    }
    
    func queryCount() -> Int?{
        do{
            let count = try Database.shared.connection?.scalar(tblUsuarios.count)
            return count
        }catch{
            let nserror = error as NSError
            print("Cannot query count usuarios, Error in : \(nserror), \(nserror.userInfo)")
            return nil
        }
    }
    
    func getUsuario(usuario : Row) -> Usuario{
        let user = Usuario(idExpediente: usuario[self.idExpediente], nombreCompleto: usuario[self.nombreCompleto], idAsignacionMembresia: usuario[self.idAsignacionMembresia], correoElectronico: usuario[self.correoElectronico], contrasenia: usuario[self.contrasenia], mensaje: "")
        return user
    }
    
    func updateCorreoElectronicoUsuario(id : Int, correo : String){
        do{
            let expediente = tblUsuarios.filter(idExpediente == id)
            try Database.shared.connection?.run(expediente.update(correoElectronico <- correo))
            
        }catch{
            let nserror = error as NSError
            print("Cannot query update usuarios, Error in : \(nserror), \(nserror.userInfo)")
        }
        
    }
    
    func updateCorreoContraseniaUsuario(id : Int, password : String){
        do{
            let expediente = tblUsuarios.filter(idExpediente == id)
            try Database.shared.connection?.run(expediente.update(contrasenia <- password))
            
        }catch{
            let nserror = error as NSError
            print("Cannot query update usuarios, Error in : \(nserror), \(nserror.userInfo)")
        }
        
    }
    
    func deleteUsuarios(){
        do{
            try Database.shared.connection?.run(tblUsuarios.delete())
        }catch{
            let nserror = error as NSError
            print("Cannot query count usuarios, Error in : \(nserror), \(nserror.userInfo)")
        }
    }
    
    func toString(usuario : Row){
        print("""
            idExpediente = \(usuario[self.idExpediente]),
            nombreCompleto = \(usuario[self.nombreCompleto]),
            idAsignacionMembrsia = \(usuario[self.idAsignacionMembresia]),
            correoElectronico = \(usuario[self.correoElectronico]),
            contrasenia = \(usuario[self.contrasenia])
            """)
    }
}

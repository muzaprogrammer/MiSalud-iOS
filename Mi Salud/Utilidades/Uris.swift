//
//  Uris.swift
//  Mi Salud
//
//  Created by ITMED on 6/8/18.
//  Copyright © 2018 ITMED. All rights reserved.
//

import Foundation

class Uris{
    
    let dominio : String = "https://appwebsv.com/misalud/API/"
    let dominioExamenesLaboratorio : String = "https://appwebsv.com/labmisalud/examenes/"
    
    func url_validar_usuario() -> String {
        return dominio + "ValidateUser"
    }
    
    func url_restaurar_contrasenia() -> String {
        return dominio + "RestaurarContrasenia"
    }
    
    func url_obtener_citas() -> String {
        return dominio + "FetchCitas"
    }
    
    func url_reservar_citas_datos_iniciales() -> String{
        return dominio + "ReservarCitas"
    }
    
    func url_obtener_horas_disponibles() -> String{
        return dominio + "ObtenerHorasDisponibles"
    }
    
    func url_guardar_cita() -> String{
        return dominio + "GuardarCita"
    }
    
    func url_obtener_detalles_cita() -> String{
        return dominio + "ObtenerDetallesCita"
    }
    
    func url_cancelar_cita() -> String{
        return dominio + "CancelarCita"
    }
    
    func url_contactanos() -> String{
        return dominio + "SaveMensajeContactanos"
    }
    
    func url_obtener_datos_generales() -> String{
        return dominio + "ObtenerDatosGenerales"
    }
    
    func url_actualizar_datos_generales() -> String{
        return dominio + "ActualizarDatosGenerales"
    }
    
    func url_cambiar_contrasenia() -> String{
        return dominio + "CambiarContrasenia"
    }
    
    func url_obtener_documentos_internos() -> String{
        return dominio + "ObtenerDocumentosInternos"
    }
    
    func url_obtener_documentos_internos_detalles(idExpediente : Int, idDocumento : Int) -> String{
        return dominio + "ObtenerDocumentosInternosDetalles?idExpediente=\(idExpediente)&idDocumento=\(idDocumento)"
    }
    
    func url_obtener_examenes_laboratorio() -> String{
        return dominio + "ObtenerExamenesLaboratorio"
    }
    
    func url_obtener_detalles_examen_laboratorio(nombreArchivo : String, idExamenLaboratorio : Int, idExpediente : Int) -> String{
        return dominioExamenesLaboratorio + "\(nombreArchivo)?id=\(idExamenLaboratorio)&ide=\(idExpediente)"
    }
    
    func url_obtener_consultas() -> String{
        return dominio + "ObtenerConsultas"
    }
    
    func url_obtener_detalles_consulta() -> String{
        return dominio + "ObtenerDetallesConsulta"
    }
    
    func url_obtener_recetas() -> String{
        return dominio + "ObtenerRecetas"
    }
    
    func url_obtener_detalles_recetas() -> String{
        return dominio + "ObtenerDetallesReceta"
    }
    
    func url_obtener_cuentas() -> String{
        return dominio + "ObtenerCuentas"
    }
    
    func url_obtener_detalles_cuenta() -> String{
        return dominio + "ObtenerDetallesCuenta"
    }
    
    func url_obtener_detalles_cuenta_consumo() -> String{
        return dominio + "ObtenerDetallesCuentaConsumo"
    }
}

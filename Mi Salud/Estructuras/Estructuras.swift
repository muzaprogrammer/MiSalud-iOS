//
//  Estructuras.swift
//  MiSalud-iOS
//
//  Created by ITMED, Ricardo Alcides Castillo Rogel on 27/6/18.
//  Copyright © 2018 ITMED. All rights reserved.
//

import Foundation

struct Usuario : Decodable
{
    var idExpediente : Int?
    var nombreCompleto : String?
    var idAsignacionMembresia : Int?
    var correoElectronico : String?
    var contrasenia : String?
    var mensaje : String?
}

struct Citas : Decodable
{
    var idCita : Int!
    var nombreSucursal : String!
    var nombrePaciente : String!
    var tipoConsulta : String!
    var fecha : String!
    var hora : String!
    var notas : String?
}

struct Respuesta : Decodable
{
    var mensaje : String!
}

struct CodigoRespuesta : Decodable
{
    var respuesta : Int!
}

struct Documentos : Decodable
{
    var idDocumento : Int!
    var idExpediente : Int!
    var tipoDocumento : String!
    var nombrePaciente : String!
    var fecha : String!
}

struct ExamenesLaboratorio : Decodable
{
    var idExamenLaboratorio : Int!
    var nombreExamen : String!
    var nombrePaciente : String!
    var fecha : String!
    var idExpediente : Int!
    var nombreArchivo : String!
}

struct Recetas : Decodable
{
    var idReceta : Int!
    var fecha : String!
    var nombrePaciente : String!
}

struct DetallesReceta : Decodable
{
    var nombreMedicamento : String!
    var cantidad : String!
    var periodo : String!
}

struct Consultas : Decodable
{
    var idConsulta : Int!
    var fecha : String!
    var nombrePaciente : String!
    var tipoConsulta : String!
}

struct ReservarCitas : Decodable
{
    var especialidades : [Especialidades]!
    var expedientes : [Expedientes]!
    var sucursales : [Sucursales]!
}

struct Especialidades : Decodable
{
    var idEspecialidad : Int!
    var nombreEspecialidad : String!
}

struct Sucursales : Decodable
{
    var idSucursal : Int!
    var nombreSucursal : String!
}

struct Expedientes : Decodable
{
    var idExpediente : Int!
    var nombrePaciente : String!
}

struct Horarios : Decodable
{
    var idHorario : String?
    var horario : String!
}

struct DetallesConsultas : Decodable
{
    var fecha : String!
    var hora : String!
    var nombrePaciente : String!
    var diagnostico : String?
    var motivoConsulta : String!
}

struct DatosGenerales : Decodable
{
    var nombreTtitular : String!
    var correoElectronico : String!
    var fechaNacimiento : String!
    var telefonoCasa : String?
    var telefonoCelular : String
}

struct Cuentas : Decodable
{
    var idCuenta : Int!
    var nombreCuenta : String!
    var fechaActivacion : String!
    var fechaVencimiento : String!
}

struct DetallesCuenta : Decodable
{
    var idAsignacionMembresia : Int!
    var idCuenta : Int!
    var nombreCuenta : String!
    var nombreTitular : String!
    var fechaActivacion : String!
    var fechaVencimiento : String!
    var consultasGratis : String!
    var saldoFavor : String!
}

struct DetallesCuentaConsumo : Decodable
{
    var nombreArticulo : String!
    var nombrePaciente : String!
    var precio : String!
    var fecha : String!
}

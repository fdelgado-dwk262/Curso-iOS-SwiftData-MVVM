//
//  FormularioCurso.swift
//  Curso-iOS-SwiftData
//
//  Created by Equipo 9 on 23/2/26.
//

import SwiftUI
import SwiftData

@Observable
class FormularioCursoViewModel {
    var codigo: String = ""
    var nombre: String = ""
    var creditos: Int = 0
    var profesor: String = ""
    
    // si es nil -> Estamos creando un curso nuevo
    // Si no es nil -> estamos editando
    private var cursoExitente: Curso?
    
    private var context: ModelContext
    
    init(context: ModelContext, curso: Curso? = nil) {
        self.context = context
        cursoExitente = curso
        
        if let curso = curso {
            codigo = curso.codigo
            nombre = curso.nombre
            creditos = curso.creditos
            profesor = curso.profesor
        }
    }
    
    // propiedades  computada para la UI
    
    var esEdicion: Bool {
        cursoExitente != nil
    }
    
    var titulo: String {
        esEdicion ? "Editar Curso" : "Nuevo Curso"
    }
    
    var esValido: Bool {
        !codigo.isEmpty && !nombre.isEmpty && !profesor.isEmpty && creditos > 0
    }
    
    func guardad() {
        if let curso = cursoExitente {
            // actualizamos y lo guarda automáticamente
            // sobre el curso y lo actualiza
            curso.codigo = codigo
            curso.nombre = nombre
            curso.creditos = creditos
            curso.profesor = profesor
        } else {
            // creamos
            let nuevoCurso = Curso(codigo: codigo,
                                   nombre: nombre,
                                   creditos: creditos,
                                   profesor: profesor)
            // inserta el nuevo curso en la base de datos local
            context.insert(nuevoCurso)
        }
    }
    
}


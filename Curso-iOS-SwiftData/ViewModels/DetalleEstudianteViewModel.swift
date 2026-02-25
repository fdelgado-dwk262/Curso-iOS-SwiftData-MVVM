//
//  DetalleEstudianteViewModel.swift
//  Curso-iOS-SwiftData
//
//  Created by Equipo 9 on 23/2/26.
//

import SwiftData
import SwiftUI

@Observable
class DetalleEstudianteViewModel {
    
    var estudiante: Estudiante?
    var context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
        cargarEstudiante()
    }
    func cargarEstudiante() {
        do {
            let descriptorEstudiante = FetchDescriptor<Estudiante>()
            estudiante = try context.fetch(descriptorEstudiante).first
            print("Detalles de: \(estudiante?.nombre) ")
        } catch {
            print("error al leer detalle del estudiante \(error)")
        }
    }
}

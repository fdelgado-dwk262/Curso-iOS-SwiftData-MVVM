//
//  EstudiantesViewModel.swift
//  Curso-iOS-SwiftData
//
//  Created by Equipo 9 on 23/2/26.
//
import SwiftUI
import SwiftData

@Observable
class EstudiantesViewModel {
    
    var todosLosEstudiantes: [Estudiante] = []
    var context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
        cargarEstudiantes()
    }
    
    func cargarEstudiantes() {
        do {
            let descriptorTodosLosEstudiantes = FetchDescriptor<Estudiante>()
            todosLosEstudiantes = try context.fetch(descriptorTodosLosEstudiantes)
            
            print("Cargados estudiantes: \(todosLosEstudiantes.count)")
        } catch {
            print("Error cargando Datos \(error)")
        }
    }
}

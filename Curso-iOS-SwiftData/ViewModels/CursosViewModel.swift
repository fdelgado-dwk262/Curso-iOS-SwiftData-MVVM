//
//  CursosViewModel.swift
//  Curso-iOS-SwiftData
//
//  Created by Equipo 9 on 23/2/26.
//

import SwiftData
import SwiftUI

@Observable
class CursosViewModel {
    
    var todosLosCursos: [Curso] = []
    var context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
        cargarCursos()
    }
    
    func cargarCursos() {
        do {
            let descriptorTodosLosCursos = FetchDescriptor<Curso>()
            todosLosCursos = try context.fetch(descriptorTodosLosCursos)
            print("cargando los cursos")
        } catch {
            print("Error cargando Datos \(error)")
        }
    }
}

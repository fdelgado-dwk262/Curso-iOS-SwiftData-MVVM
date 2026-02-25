//
//  MatriculasVieewModel.swift
//  Curso-iOS-SwiftData
//
//  Created by Equipo 9 on 20/2/26.
//
// 👀 -------------------------
// al estar fuera de la vista necesitamos el descroptor
// para poder acceder a la base de datos
// ----------------------------

import SwiftData
import SwiftUI

@Observable
class MatriculasViewModel {

    var todasLasMatriculas: [Matricula] = []
    var matriculasAprobadas: [Matricula] = []
    var matriculasDeAlumno: [Matricula] = []

    private var context: ModelContext

    init(context: ModelContext) {
        self.context = context
        // para cuando se inicialice el init haga la llamada
        cargarDatos()
    }

    func cargarDatos(nombreAlumno: String? = nil) {
        // no retorna sino rellena datos previamente definidos
        do {
            let descriptorTodas = FetchDescriptor<Matricula>(
                sortBy: [SortDescriptor(\.fechaMatricula, order: .reverse)]
            )
            todasLasMatriculas = try context.fetch(descriptorTodas)

            let filtroAprovadas = #Predicate<Matricula> { matricula in
                (matricula.calificacion ?? 0.0) >= 5.0
            }

            let descriptorAprovadas = FetchDescriptor<Matricula>(
                predicate: filtroAprovadas,
                sortBy: [SortDescriptor(\.fechaMatricula, order: .reverse)]
            )
            matriculasAprobadas = try context.fetch(descriptorAprovadas)
            
            if let nombreABuscar = nombreAlumno {
                let filtroAlumno = #Predicate<Matricula> { matricula in
                    matricula.estudiante?.nombre.contains(nombreABuscar) == true
                }
                let descriptorAlumnos = FetchDescriptor<Matricula>(predicate: filtroAlumno)
                matriculasDeAlumno = try context.fetch(descriptorAlumnos)
            }
            
            
        } catch {
            print("Error cargando Datos \(error)")
        }
    }
    
    func eliminarMatricula(matricula: Matricula) {
        context.delete(matricula)
        // hay que recargar los arrays para que la UI se entere de los cambios y el borrado
        // al no tener el Query que hemos borrado en el refactor
        cargarDatos()

    }

}

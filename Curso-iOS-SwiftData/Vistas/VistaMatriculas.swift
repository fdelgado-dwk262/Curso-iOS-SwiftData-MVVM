//
//  VistaMatriculas.swift
//  Curso-iOS-SwiftData
//
//  Created by Equipo 9 on 20/2/26.
//
import SwiftUI
import SwiftData

struct VistaMatriculas: View {
    
    
    @Environment(\.modelContext) private var context
    @State private var viewModel: MatriculasViewModel
    
    init(context: ModelContext) {
        _viewModel = State(initialValue: MatriculasViewModel(context: context))
        
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section("Todas las matrículas") {
                    ForEach(viewModel.todasLasMatriculas) { matricula in
                        VStack(alignment: .leading) {
                            Text("\(matricula.estudiante?.nombre ?? "N/A") - \(matricula.curso?.nombre ?? "N/A")")
                            Text("Semestre: \(matricula.semestre)")
                        }
                    }
                    // podemos marcar varias para hacer un borrado masivo de las marcadas
                    .onDelete { indides in
                        indides.forEach { indice in
                            let matricula = viewModel.todasLasMatriculas[indice]
                            viewModel.eliminarMatricula(matricula: matricula)
                        }
                    }
                }
                
                Section("Matrículas aprobadas") {
                    ForEach(viewModel.matriculasAprobadas) { matricula in
                        Text("\(matricula.estudiante?.nombre ?? "N/A") - \(matricula.calificacion ?? 0.0, specifier: "%.2f")")
                    }
                }
                
                Section("Matriculas de un alumno concreto") {
                    ForEach(viewModel.matriculasDeAlumno) { matricula in
                        Text("\(matricula.estudiante?.nombre ?? "N/A") - \(matricula.calificacion ?? 0.0, specifier: "%.2f")")
                    }
                }
            }
            
            .navigationTitle("Matrículas")
            
            // para realizar la carga de datos al inicio
            .onAppear{
                // puede inicializarse sin variable pero es por el ejemplo
                viewModel.cargarDatos(nombreAlumno: "Carlos")
            }
        }
    }
}

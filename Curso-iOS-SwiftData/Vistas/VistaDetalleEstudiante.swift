//
//  VistaDetalleEstudiante.swift
//  Curso-iOS-SwiftData
//
//  Created by Equipo 9 on 23/2/26.
//


import SwiftData
import SwiftUI

struct VistaDetalleEstudiante: View {
    let estudiante: Estudiante

    @State private var viewModel: DetalleEstudianteViewModel

    @State private var mostrarMatricular = false
    
    init(context: ModelContext, estudiante: Estudiante) {
        _viewModel = State(initialValue: DetalleEstudianteViewModel(context: context))
        self.estudiante = estudiante
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Datos del estudiante
            VStack(alignment: .leading, spacing: 10) {
                Text(viewModel.estudiante?.nombre ?? "" )
                    .font(.title)
                Text(viewModel.estudiante?.email ?? "")
                    .foregroundStyle(.secondary)
                Text("Nacimiento: \(viewModel.estudiante?.fechaNacimiento ?? Date(), style: .date)")
                    .font(.caption)
            }
            .padding()
            
            List {
                Section("Cursos matriculados") {
                    if let matriculas = viewModel.estudiante?.matriculas,
                       !matriculas.isEmpty {
                        ForEach(matriculas) { matricula in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(matricula.curso?.nombre ?? "Sin curso")
                                        .font(.headline)
                                    Text("Semestre: \(matricula.semestre)")
                                        .font(.caption)
                                    if let calificacion = matricula.calificacion {
                                        Text("Calificación: \(calificacion, specifier: "%.2f")")
                                            .font(.caption)
                                            .foregroundStyle(calificacion >= 5.0 ? .green : .red)
                                    }
                                }
                                Spacer()
                                Button("Eliminar") {
                                    viewModel.context.delete(matricula)
                                }
                                .buttonStyle(.bordered)
                                .tint(.red)
                            }
                        }
                        
                    } else {
                        Text("No tiene cursos matriculados")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            
            Spacer()
        }
        .navigationTitle("Detalle Estudiante")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Matricular en curso") {
                    mostrarMatricular = true
                }
            }
        }
        .sheet(isPresented: $mostrarMatricular) {
            VistaMatricularEstudiante(estudiante: viewModel.estudiante!)
        }
    }
}

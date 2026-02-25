//
//  VistaEstudiantes.swift
//  Curso-iOS-SwiftData
//
//  Created by Equipo 9 on 23/2/26.
//


import SwiftData
import SwiftUI

struct VistaEstudiantes: View {

    @State private var viewModel: EstudiantesViewModel
    @State private var mostrarNuevoEstudiante = false
    init(context: ModelContext) {
    _viewModel = State(initialValue: EstudiantesViewModel(context: context))
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.todosLosEstudiantes) { estudiante in
                    NavigationLink(destination: VistaDetalleEstudiante(context: viewModel.context, estudiante: estudiante, )) {
                        VStack(alignment: .leading) {
                            Text(estudiante.nombre)
                                .font(.headline)
                            Text(estudiante.email)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text("Cursos: \(estudiante.cursos.count)")
                        }
                    }
                }
                .onDelete { indices in
                    for indice in indices {
                        viewModel.context.delete(viewModel.todosLosEstudiantes[indice])
                    }
                }
            }
            .navigationTitle("Estudiantes")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Agregar") {
                        mostrarNuevoEstudiante.toggle()
                    }
                }
            }
            .sheet(isPresented: $mostrarNuevoEstudiante) {
                VistaNuevoEstudiante(context: viewModel.context)
            }
            // podemos dejar esto aqui o poner una Query arriba y eliminar el onapear
            // según el 
            .onAppear {
                viewModel.cargarEstudiantes()
            }
        }
    }
}

//
//  VistaCursos.swift
//  Curso-iOS-SwiftData
//
//  Created by Equipo 9 on 23/2/26.
//

import SwiftData
import SwiftUI

struct VistaCursos: View {

    @State private var viewModel: CursosViewModel

    @State private var mostrarNuevoCurso = false
    @State private var cursoSelecionado: Curso?

    init(context: ModelContext) {
        _viewModel = State(initialValue: CursosViewModel(context: context))
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.todosLosCursos) { curso in
                    VStack(alignment: .leading) {
                        Text(curso.nombre)
                            .font(.headline)
                        Text("Código: \(curso.codigo)")
                            .font(.caption)
                        Text("Profesor: \(curso.profesor)")
                            .font(.caption)
                        Text("Estudiantes: \(curso.estudiantes.count)")
                            .font(.caption)
                    }
                    .onTapGesture {
                        cursoSelecionado = curso
                    }
                }
            }

            .navigationTitle("Cursos")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Agregar") {
                        mostrarNuevoCurso = true
                    }
                }
            }

            .sheet(
                isPresented: $mostrarNuevoCurso,
                onDismiss: {
                    viewModel.cargarCursos()
                },
                content: {
                    VistaFormularioCurso(context: viewModel.context)
                }
            )

            .sheet(
                item: $cursoSelecionado,
                onDismiss: {
                    viewModel.cargarCursos()
                },
                content: { curso in
                    VistaFormularioCurso(
                        context: viewModel.context,
                        curso: curso
                    )
                }
            )

            .onAppear {
                // puede inicializarse sin variable pero es por el ejemplo
                viewModel.cargarCursos()
            }
        }
    }
}

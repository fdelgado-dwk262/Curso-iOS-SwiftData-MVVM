//
//  VistaNuevoEstudiante 2.swift
//  Curso-iOS-SwiftData
//
//  Created by Equipo 9 on 20/2/26.
//
import SwiftUI
import SwiftData

struct VistaNuevoEstudiante: View {

    @Environment(\.dismiss) private var dismiss

    // los parametros
    @State private var viewModel: NuevoEstudianteViewModel
    
    init(context:ModelContext) {
        _viewModel = State(initialValue: NuevoEstudianteViewModel(context: context))
    }
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Nombre", text: $viewModel.nombre)
                
                TextField("Email", text: $viewModel.email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                
                DatePicker("Fecha de nacimiento",
                           selection: $viewModel.fechaNacimiento,
                        displayedComponents: .date)
            }
            .navigationTitle("Nuevo estudiante")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        viewModel.guardar()
                        dismiss()
                    }
                    .disabled(!viewModel.esValido)
                }
            }
        }
    }
}

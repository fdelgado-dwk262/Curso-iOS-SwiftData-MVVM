//
//  Estudiantes.swift
//  Curso-iOS-SwiftData
//
//  Created by Equipo 2 on 18/2/26.
//

import SwiftData
import SwiftUI

@Model
class Estudiante {
    var id: UUID
    var nombre: String
    var email: String
    var fechaNacimiento: Date

    // Relación 1 a muchos: Un estudiante puede tener múltiples matrículas (0..N)
    @Relationship(deleteRule: .cascade)  // si se borra el estudiante se borran sus matrículas
    var matriculas: [Matricula]?

    // Propiedad computada para obtener los cursos (a través de Matriculas)
    var cursos: [Curso] {
        matriculas?.compactMap { $0.curso } ?? []
    }

    init(nombre: String, email: String, fechaNacimiento: Date) {
        self.id = UUID()
        self.nombre = nombre
        self.email = email
        self.fechaNacimiento = fechaNacimiento
        self.matriculas = []
    }
}

@Model
class Curso {
    var id: UUID
    var codigo: String
    var nombre: String
    var creditos: Int
    var profesor: String

    // Relación 1 a muchos: Un curso puede tener MÚLTIPLES matrículas
    @Relationship(deleteRule: .nullify)  // si borramos el curso, las matrículas se quedan sin curso
    var matriculas: [Matricula]?

    // Relación muchos a muchos: Un curso tiene muchos estudiantes
    // y los estudiantes se matriculan en muchos cursos.
    var estudiantes: [Estudiante] {
        return matriculas?.compactMap { $0.estudiante } ?? []
    }

    init(codigo: String, nombre: String, creditos: Int, profesor: String) {
        self.id = UUID()
        self.codigo = codigo
        self.nombre = nombre
        self.creditos = creditos
        self.profesor = profesor
        self.matriculas = []
    }
}

@Model
class Matricula {
    var id: UUID
    var fechaMatricula: Date
    var calificacion: Double?
    var semestre: String

    // Relación muchos a 1:
    // Un estudiante puede tener varias matrículas
    // cada matrícula pertenece a UN estudiante.
    var estudiante: Estudiante?

    // Relación muchos a 1: cada matrícula es para UN curso
    var curso: Curso?

    init(
        estudiante: Estudiante? = nil,
        curso: Curso? = nil,
        semestre: String,
        calificacion: Double? = nil
    ) {

        self.id = UUID()
        self.fechaMatricula = Date()
        self.semestre = semestre
        self.calificacion = calificacion
        self.estudiante = estudiante
        self.curso = curso
    }
}

struct ContentView: View {

    var body: some View {
        TabView {
            VistaEstudiantes()
                .tabItem {
                    Label("Estudiantes", systemImage: "person.3")
                }
            VistaCursos()
                .tabItem {
                    Label("Cursos", systemImage: "book")
                }
            Text("VistaMatriculas()")
                .tabItem {
                    Label("Matrículas", systemImage: "list.bullet.clipboard")
                }
        }
    }
}

struct VistaEstudiantes: View {
    @Environment(\.modelContext) private var context
    @Query private var estudiantes: [Estudiante]
    @State private var mostrarNuevoEstudiante = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(estudiantes) { estudiante in
                    NavigationLink(destination: Text("VistaDetalleEstudiante")) {
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
                        context.delete(estudiantes[indice])
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
                Text("VistaNuevoEstudiante")
            }
        }
    }
}

struct VistaCursos: View {
    @Query private var cursos: [Curso]
    @State private var mostrarNuevoCurso = false
    
    var body: some View {
        NavigationStack {
            List {
                
            }
            
            .navigationTitle("Cursos")
        }
    }
    
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(
        for: Estudiante.self,
        Curso.self,
        Matricula.self,
        configurations: config
    )
    
    crearDatosEjemplo(container: container)

    return ContentView()
        .modelContainer(container)
}

func crearDatosEjemplo(container: ModelContainer) {
    let context = ModelContext(container)
    
    let estudiante1 = Estudiante(
        nombre: "Ana García",
        email: "ana.garcia@uni.edu",
        fechaNacimiento: Calendar.current.date(from: DateComponents(year: 1990, month: 5, day: 15))!
    )

    let estudiante2 = Estudiante(
        nombre: "Carlos Pérez",
        email: "carlos.perez@uni.edu",
        fechaNacimiento: Calendar.current.date(from: DateComponents(year: 2000, month: 2, day: 11))!
    )
    
    let curso1 = Curso(
        codigo: "CAL101", nombre: "Cálculo I", creditos: 4, profesor: "Sr. Gómez"
    )
    
    let curso2 = Curso(
        codigo: "SWF1", nombre: "Intro a Swift", creditos: 3, profesor: "Sr. Eduardo"
    )
    
    let matricula1 = Matricula(
        estudiante: estudiante1,
        curso: curso1,
        semestre: "2026-1",
        calificacion: 8.5
    )
    
    let matricula2 = Matricula(
        estudiante: estudiante1,
        curso: curso2,
        semestre: "2026-1"
    )
    
    let matricula3 = Matricula(
        estudiante: estudiante2,
        curso: curso1,
        semestre: "2025-1",
        calificacion: 3
    )
    
    context.insert(estudiante1)
    context.insert(estudiante2)
    
    context.insert(curso1)
    context.insert(curso2)
    
    context.insert(matricula1)
    context.insert(matricula2)
    context.insert(matricula3)
    
    // Persistir los cambios manualmente (para que funcione en la Preview)
    try? context.save()
}

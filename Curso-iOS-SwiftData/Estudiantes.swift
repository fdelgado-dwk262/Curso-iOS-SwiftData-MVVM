//
//  Estudiantes.swift
//  Curso-iOS-SwiftData
//
//  Created by Equipo 2 on 18/2/26.
//

import SwiftData
import SwiftUI



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

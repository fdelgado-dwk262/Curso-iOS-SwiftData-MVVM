//
//  Curso_iOS_SwiftDataApp.swift
//  Curso-iOS-SwiftData
//
//  Created by Equipo 2 on 17/2/26.
//

import SwiftUI
import SwiftData

@main
struct Curso_iOS_SwiftDataApp: App {
    var body: some Scene {
        WindowGroup {
            VistaTareas()
        }
        .modelContainer(for: Tarea.self)
    }
}

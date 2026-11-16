// Plantilla de Secrets.swift
//
// 1. Copia este archivo a Moonvies/Config/ con el nombre Secrets.swift
// 2. Cambia "PEGA_AQUI_TU_TOKEN" por tu "API Read Access Token" de TMDB
//
// Secrets.swift está en el .gitignore: nunca se sube al repositorio.
// Esta plantilla vive en Docs/, fuera del proyecto, así que Xcode no la compila.

import Foundation

/// Llaves privadas (este archivo está en el `.gitignore`)
enum Secrets {
    /// "API Read Access Token" de TMDB
    static let tmdbToken = "PEGA_AQUI_TU_TOKEN"
}

import Foundation


protocol MovieRepository {
    func fetchMovies() async throws -> [Movie]
}


struct MockMovieRepository: MovieRepository {
    
    let shouldFail: Bool

    func fetchMovies() async throws -> [Movie] {
       
        try await Task.sleep(for: .seconds(1))

        guard !shouldFail else {
            throw MovieError.internetError
        }

        return MockMovies().all
    }
}

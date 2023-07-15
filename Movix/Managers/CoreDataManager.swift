//
//  CoreDataManager.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 14.07.2023.
//

import CoreData

enum MovieStatus: String {
    case searchHistory = "Search History"
    case favoriteMovies = "Favorites"
    case watchlist = "Watchlist"
    case watchHistory = "Watched"
}

class CoreDataManager {
    static let shared = CoreDataManager()
    
    enum CoreDataError: Error {
        case failedToSaveData
        case failedToFetchData
        case failedToDeleteData
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Movix")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error: \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var managedObjectContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private init() {}
    
    func addMovie(movie: Movie, status: MovieStatus) throws {
        let context = managedObjectContext
        let entity = NSEntityDescription.entity(forEntityName: "Movies", in: context)!
        let movieEntity = NSManagedObject(entity: entity, insertInto: context)
        
        movieEntity.setValue(movie.id, forKey: "movieId")
        movieEntity.setValue(movie.posterPath, forKey: "posterPath")
        movieEntity.setValue(movie.releaseDate, forKey: "releaseDate")
        movieEntity.setValue(movie.title, forKey: "title")
        movieEntity.setValue(movie.voteAverage, forKey: "voteAverage")
        movieEntity.setValue(movie.runtime, forKey: "runtime")
        movieEntity.setValue(status.rawValue, forKey: "status")
        
        try saveContext()
    }
    
    func removeMovie(movie: Movie, status: MovieStatus) throws {
        let context = managedObjectContext
        let fetchRequest: NSFetchRequest<Movies> = Movies.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "movieId = %@ AND status = %@", movie.id! as NSNumber, status.rawValue)
        
        do {
            let results = try context.fetch(fetchRequest)
            for movieEntity in results {
                context.delete(movieEntity)
            }
            
            try saveContext()
        } catch {
            throw CoreDataError.failedToDeleteData
        }
    }
    
    func fetchMovies(withStatus status: MovieStatus) throws -> [Movie] {
        let context = managedObjectContext
        let fetchRequest: NSFetchRequest<Movies> = Movies.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "status = %@", status.rawValue)
        
        do {
            let results = try context.fetch(fetchRequest)
            let reversedResults = results.reversed()
            return reversedResults.compactMap { movieEntity in
                return Movie(
                    id: Int(movieEntity.movieId),
                    overview: nil,
                    posterPath: movieEntity.posterPath,
                    releaseDate: movieEntity.releaseDate,
                    title: movieEntity.title,
                    voteAverage: movieEntity.voteAverage,
                    runtime: Int(movieEntity.runtime),
                    genres: nil
                )
            }
        } catch {
            throw CoreDataError.failedToFetchData
        }
    }
    
    
    func removeAllMovies(status: MovieStatus) throws {
        let context = managedObjectContext
        let fetchRequest: NSFetchRequest<Movies> = Movies.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "status = %@", status.rawValue)
        
        do {
            let results = try context.fetch(fetchRequest)
            for movieEntity in results {
                context.delete(movieEntity)
            }
            
            try saveContext()
        } catch {
            throw CoreDataError.failedToDeleteData
        }
    }
    
    func saveContext() throws {
        let context = managedObjectContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                throw CoreDataError.failedToSaveData
            }
        }
    }
}

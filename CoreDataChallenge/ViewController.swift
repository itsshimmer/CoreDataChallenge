//
//  ViewController.swift
//  CoreDataChallenge
//
//  Created by João Brentano on 17/03/22.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    var persistentContainer: NSPersistentContainer {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError()
        }
        
        return appDelegate.persistentContainer
    }

    @IBOutlet weak var textView: UITextView!
    
    @IBAction func showDataAction(_ sender: Any) {
        
        do {
            let movies = try persistentContainer.viewContext.fetch(Movie.fetchRequest())
            let formatted = movies.map { "\t\($0)" }.joined(separator: "\n")
            textView.text = "Query - all movies:\n\(formatted)\n\(textView.text ?? "")"
        } catch {
            textView.text = "Error on query: \(error)\n\(textView.text ?? "")"
        }
        
    }
    
    @IBAction func createDataAction(_ sender: Any) {
        
        let newActor = MovieActor(context: persistentContainer.viewContext)
        newActor.name = "Actor"
        newActor.birthDate = .now
        newActor.gender = "gender"

        let newProductionCompany = ProductionCompany(context: persistentContainer.viewContext)
        newProductionCompany.name = "Production Company"
        newProductionCompany.country = "Brazil"
        newProductionCompany.website = "http://prodcomp.com.br/"
        
        let newMovie = Movie(context: persistentContainer.viewContext)
        newMovie.name = "Movie"
        newMovie.length = 120
        newMovie.releaseDate = .now
        newMovie.revenue = 0.0
        newMovie.actors = NSSet(array: [newActor])
        newMovie.productionComopany = newProductionCompany

    }
    
    @IBAction func saveDataAction(_ sender: Any) {
        
        do {
            try persistentContainer.viewContext.save()
            textView.text = "Saved\n\(textView.text ?? "")"
        } catch {
            textView.text = "Error on save: \(error)\n\(textView.text ?? "")"
        }
        
    }
    
    @IBAction func deleteDataAction(_ sender: Any) {
        
        do {
            let allMovies = try persistentContainer.viewContext.fetch(Movie.fetchRequest())
            allMovies.forEach {
                persistentContainer.viewContext.delete($0)
            }
            
            let allMovieActors = try persistentContainer.viewContext.fetch(MovieActor.fetchRequest())
            allMovieActors.forEach {
                persistentContainer.viewContext.delete($0)
            }
            
            let allProductionCompanies = try persistentContainer.viewContext.fetch(ProductionCompany.fetchRequest())
            allProductionCompanies.forEach {
                persistentContainer.viewContext.delete($0)
            }
            
            try persistentContainer.viewContext.save()
            
            textView.text = "Deleted\n\(textView.text ?? "")"
        } catch {
            textView.text = "Error on deletion: \(error)\n\(textView.text ?? "")"
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}


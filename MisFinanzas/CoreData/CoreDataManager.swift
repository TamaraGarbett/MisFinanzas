import Foundation
import CoreData

class CoreDataManager{
    private let container : NSPersistentContainer!
    
    init() {
        container = NSPersistentContainer(name: "MisFinanzas")
        setupDatabase()
    }
    
    private func setupDatabase() {
        container.loadPersistentStores { (desc, error) in
            if let error = error {
                print("Error loading store \(desc) — \(error)")
                return
            }
            print("Database ready!")
        }
    }
    
    func createUser(email:String,password:String,question:String,answer:String){
        let context = container.viewContext
        
        let user = User(context: context)
        user.email = email
        user.password = password
        user.question = question
        user.answer = answer
        
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        do {
            try context.save()
            print("Usuario \(email) guardado")
        } catch {
            print("Error guardando usuario — \(error)")
        }
    }
    
    func fetchUser(email:String) -> User? {
        let fetchRequest = NSFetchRequest<User>(entityName: "User")
        let predicate = NSPredicate(format: "email == %@", email)
        fetchRequest.predicate = predicate
        do{
            let result = try container.viewContext.fetch(fetchRequest)
            if result.count > 0{
                return result[0]
            }else{
                return nil
            }
        } catch {
            print("Error al obtener el usuario")
        }
        return nil
    }
}

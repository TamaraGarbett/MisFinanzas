import Foundation
import CoreData

class CoreDataManager{
    private let container : NSPersistentContainer!
    
    //Constructor que inicializa la BD
    init() {
        container = NSPersistentContainer(name: "Model")
        setupDatabase()
    }
    
    private func setupDatabase() {
        //Inicializa y completa el Core data stack
        container.loadPersistentStores { (desc, error) in
            if let error = error {
                print("Error loading store \(desc) — \(error)")
                return
            }
            print("Database ready!")
        }
    }
    
    //Funcion para crear un usuario en la BD
    //Recibe por parametro un email, contraseña, pregunta de seguridad y respuesta, ingresadas por el usuario.
    func createUser(email:String,password:String,question:String,answer:String){
        //Obtengo el contexto de la BD
        let context = container.viewContext
        //Creo un objeto de tipo User, pasando como parametro el contexto de la BD
        let user = User(context: context)
        //Asigno los datos ingresados a los atributos del User
        user.email = email
        user.password = password
        user.question = question
        user.answer = answer
        
        //Intento guardar el contexto de la BD
        do {
            try context.save()
            print("Usuario \(email) guardado")
        } catch {
            //En caso de error lo muestro por consola
            print("Error guardando usuario — \(error)")
        }
    }
    
    //Funcion que busca un usuario en la BD tomando como criterio un email ingresado por parametro
    //Devuelve un objeto User con los datos del mismo en caso de que exista o nil en caso de que no exista
    func fetchUser(email:String) -> User? {
        //Creo el fetchRequest pasandole como parametro el nombre de la entidad en la cual quiero buscar
        let fetchRequest = NSFetchRequest<User>(entityName: "User")
        //Creo el predicado con el formato que el email en la BD coincida con el email ingresado por el usuario
        let predicate = NSPredicate(format: "email == %@", email)
        fetchRequest.predicate = predicate
        //Intento obtener la request de la BD
        do{
            let result = try container.viewContext.fetch(fetchRequest)
            //Si la cantidad de resultados es mayor a cero significa que tengo datos
            if result.count > 0{
                //Devuelvo la posicion cero del vector debido a que unicamente puedo tener un objeto vinculado a un email
                return result[0]
            }else{
                //En caso de que la cantidad de resultados sea cero devuelvo nil, debido a que no existe el usuario en la BD
                return nil
            }
        } catch {
            print("Error al obtener el usuario")
        }
        return nil
    }
    
    //Funcion para cambiar la contraseña
    //Recibe por parametro el usuario al que se le cambiara la contraseña y la nueva contraseña
    func changePassword(user:User, newPassword:String){
        let context = container.viewContext
        
        user.password = newPassword
        do{
            try context.save()
            print("Contraseña \(user.password!) guardada")
        } catch {
            print("Error guardando contraseña - \(error)")
        }
    }
    
    //Funcion para autenticar a un usuario
    //Recibe por parametro el email y contraseña ingresada por el usuario
    //Devuelve true si los datos ingresados son correctos y false en caso de que no
    func authentication(email:String, password:String) ->Bool{
        let user = fetchUser(email: email)
        if user != nil && user?.password == password{
            return true
        }else{
            return false
        }
    }
    //Funcion para borrar los datos de una entidad en la BD
    //ESTA FUNCION SE USA UNICAMENTE PARA REALIZAR LAS PRUEBAS DE LA APLICACION
    func clearDataBase(entity:String){
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try container.persistentStoreCoordinator.execute(deleteRequest, with: container.viewContext)
        } catch let error as NSError {
            print("Error \(error)")
        }
    }
  
    //Funcion para crear un gasto en la BD
    func createImporte(amount:Double, date:Date, descriptionImporte:String, type:Int32, fixedCost:Bool, category: Int32){
        let id = BudgetViewController.loggedUser?.objectID
        //Obtengo el contexto de la BD
        let context = container.viewContext
        if let user = context.object(with: id!) as? User {
            //Creo un objeto de tipo User, pasando como parametro el contexto de la BD
            let importe = Importe(context: context)
            //Asigno los datos ingresados a los atributos del User
            importe.belongsTo = user
            importe.amount = amount
            importe.date = date
            importe.descriptionImporte = descriptionImporte
            importe.type = type
            importe.fixedCost = fixedCost
            importe.category = category
            //Intento guardar el contexto de la BD
            do {
                try context.save()
                print("Importe del usuario \(user.email!) guardado")
            } catch {
                //En caso de error lo muestro por consola
                print("Error guardando usuario — \(error)")
            }
        }
    }
}

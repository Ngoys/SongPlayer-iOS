import Foundation
import CoreData

class CoreDataStack {

    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------

    lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores { _, error in
            if let error = error {
                print("CoreDataStack - Error \(error)")
            }
        }
        return container
    }()

    lazy var mainContext: NSManagedObjectContext = {
        let context = self.storeContainer.viewContext
        return context
    }()

    lazy var backgroundContext: NSManagedObjectContext = {
        let context = self.storeContainer.newBackgroundContext()
        context.automaticallyMergesChangesFromParent = true
        return context
    }()

    //----------------------------------------
    // MARK: - Internals
    //----------------------------------------

    private let modelName = "SongPlayer"
}

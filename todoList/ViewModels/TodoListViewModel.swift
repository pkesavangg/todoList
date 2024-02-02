//
//  TodoListViewModel.swift
//  todoList
//
//  Created by Kesavan Panchabakesan on 29/07/23.
//

import Foundation
import CoreData

class TodoListViewModel : ObservableObject {
    @Published var savedEntites: [TodoListEntity] = []
    @Published var categories: [String] = []
    @Published var todoList: [String: [TodoListEntity]] = [:]
    @Published var sortedBy = "Category"
    
    let userDefaults = UserDefaults.standard
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "TodoListContainer")
        container.loadPersistentStores {( description, error) in
            if let error = error {
                print(error)
            }
            else {
                print("TodoListContainer loaded successfully.")
            }
        }
        self.fetchList()
        self.getCategoriesFromUserDefaults()
    }
    
    
    var filteredTodoList : [String: [TodoListEntity]] {
        switch(sortedBy) {
        case "Due Date" :
            return Dictionary(grouping: self.savedEntites, by: { $0.dueDate?.formatted(.dateTime.day().month().year()) ?? "" })
        case "Completion status" :
            let todoDict = Dictionary(grouping: self.savedEntites, by: { $0.isCompleted })
            var updatedDict: [String: [TodoListEntity]] = [:]
            for (key, value) in todoDict {
                let newKey = key ? "Completed" : "Not completed"
                updatedDict[newKey] = value
            }
            return updatedDict
        default:
            return Dictionary(grouping: self.savedEntites, by: { $0.category! })
        }
    }
    
    func saveCategories() {
        UserDefaults.standard.set(self.categories, forKey: "categoriesStorageKey")
        self.getCategoriesFromUserDefaults()
    }
    
    func getCategoriesFromUserDefaults() {
        self.categories =  UserDefaults.standard.array(forKey: "categoriesStorageKey") as? [String] ?? []
        if(!self.categories.contains("Others")){
            self.categories.append("Others")
        }
    }
    
    
    func fetchList() {
        let request = NSFetchRequest<TodoListEntity>(entityName: "TodoListEntity")
        do {
            self.savedEntites = try container.viewContext.fetch(request)
        } catch (let error) {
            print(error, "Error in fetch list")
        }
    }
    
    func addNewItem(todoDescription: String, category: String, dueDate: Date) {
        let newItem = TodoListEntity(context: container.viewContext)
        newItem.dueDate = dueDate
        newItem.category = category
        newItem.todoDescription = todoDescription
        newItem.isCompleted = false
        self.saveData()
    }
    
    func updateItem(entity: TodoListEntity, _ completionStatus: Bool) {
        entity.isCompleted = completionStatus
        self.saveData()
    }
    
    func deleteItem(indexSet: IndexSet) {
        guard let index = indexSet.first else {
            return
        }
        let entity = self.savedEntites[index]
        self.container.viewContext.delete(entity)
        self.saveData()
    }
    
    func saveData() {
        do {
            try container.viewContext.save()
            self.fetchList()
        } catch (let error) {
            print(error, "Error in saving data")
        }
    }
}

//
//  AddTodoItemView.swift
//  todoList
//
//  Created by Kesavan Panchabakesan on 29/07/23.
//

import SwiftUI

struct AddTodoItemView: View {
    @State private var category = "Other"
    @State private var todoDescription = ""
    @State private var date = Date.now
    @ObservedObject var viewModel : TodoListViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                
                TextField("Enter todo description", text: $todoDescription)
                    .font(.headline)
                    .padding(.leading)
                    .frame(height: 55)
                    .background(Color(red: 223 / 255.0, green: 227 / 255.0, blue: 222 / 255.0))
                    .cornerRadius(10)
                    .font(.largeTitle)
                    .padding(.top)
                
                DatePicker(selection: $date, displayedComponents: .date) {
                    Text("Due date:")
                        .foregroundColor(.black)
                        .font(.headline)
                }
                
                Picker("Category:", selection: $category) {
                    ForEach(viewModel.categories, id: \.self) {
                        Text($0)
                            .padding(.trailing)
                    }
                }
                .foregroundColor(.black)
                .font(.headline)
                .pickerStyle(.navigationLink)
                
                Button {
                    viewModel.addNewItem(todoDescription: self.todoDescription, category: category, dueDate: date)
                    self.todoDescription = ""
                    self.category = "Others"
                    self.date = Date.now
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Add item")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color(.gray))
                        .cornerRadius(10)
                        .opacity(self.todoDescription == "" ? 0.6 : 1)
                }
                .disabled(self.todoDescription == "")
                Spacer()
            }
            .padding(.horizontal)
            .navigationTitle("Add To-do item:")
        }
        
    }
}

//struct AddTodoItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddTodoItemView()
//    }
//}

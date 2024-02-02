//
//  MainView.swift
//  todoList
//
//  Created by Kesavan Panchabakesan on 29/07/23.
//


import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = TodoListViewModel()
    @State private var canShowAddCategoryModal = false
    @State private var canShowAddTodoModal = false
    
    let sortedByOptions = ["Category", "Due Date", "Completion status"]
    
    @State private var toggleCompletionStatus = false
    var body: some View {
        NavigationView {
            VStack{
                List {
                    ForEach(viewModel.filteredTodoList.sorted{ $0.key < $1.key }, id: \.0) { (category, todoItems) in
                        DisclosureGroup{
                            ForEach(todoItems) { item in
                                VStack(alignment: .leading, spacing: 10) {
                                    HStack{
                                        VStack{
                                            Text("ddddd:")
                                                .fontWeight(.bold)
                                            Spacer()
                                        }
                                        Text(item.todoDescription ?? "")
                                    }
                                    
                                    if let date = item.dueDate {
                                        HStack{
                                            Text("Due date:")
                                                .fontWeight(.bold)
                                            Text("\(date.formatted(.dateTime.day().month().year()))" )
                                        }
                                    }
                                    
                                    HStack{
                                        Toggle("Completed", isOn: Binding(
                                            get: { item.isCompleted },
                                            set: { newValue in
                                                item.isCompleted = newValue
                                                viewModel.updateItem(entity: item, newValue)
                                            }
                                        ))
                                        .fontWeight(.bold)
                                    }
                                }
                                .padding()
                            }
                        } label: {
                            HStack{
                                Text(category)
                                    .font(.callout)
                                    .padding(.leading, 20)
                            }
                        }
                    }
                    .listRowInsets(.init(top: 0,
                                         leading: 0,
                                         bottom: 0,
                                         trailing: 20))
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Picker("", selection: $viewModel.sortedBy) {
                        ForEach(sortedByOptions, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                ToolbarItem(placement: .bottomBar) {
                    Button("Add item") {
                        self.canShowAddTodoModal = true
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    Button("Add category") {
                        self.canShowAddCategoryModal = true
                    }
                }
            }
            .navigationTitle("To-do List:")
            .sheet(isPresented: $canShowAddCategoryModal) {
                AddCategoryView(viewModel: viewModel)
            }
            .sheet(isPresented: $canShowAddTodoModal) {
                AddTodoItemView(viewModel: viewModel)
            }
        }
    }
}



struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

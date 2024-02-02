//
//  CategoriesView.swift
//  todoList
//
//  Created by Kesavan Panchabakesan on 29/07/23.
//

import SwiftUI

struct AddCategoryView: View {
    @ObservedObject var viewModel : TodoListViewModel
    @State private var categoryName = ""
    @State private var showAlert = false
    var body: some View {
        NavigationView {
            VStack(spacing: 20){
                TextField("Add new category", text: $categoryName)
                    .font(.headline)
                    .padding(.leading)
                    .frame(height: 55)
                    .background(Color(red: 223 / 255.0, green: 227 / 255.0, blue: 222 / 255.0))
                    .cornerRadius(10)
                    .padding(.horizontal)
                
                Button {
                    if !viewModel.categories.contains(self.categoryName) {
                        viewModel.categories.append(self.categoryName)
                        viewModel.saveCategories()
                        self.categoryName = ""
                    }
                    else{
                        self.showAlert = true
                    }
                } label: {
                    Text("Add category")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color(.gray))
                        .cornerRadius(10)
                    
                        .opacity(self.categoryName == "" || self.categoryName.count > 25 ? 0.6 : 1)
                }
                .padding(.horizontal)
                .disabled(self.categoryName == "" || self.categoryName.count > 25)
                .alert("This category is already created try a new one.", isPresented: $showAlert) {
                    Button("OK", role: .cancel) { }
                }
                
                HStack{
                    Text("Categories: ")
                        .font(.headline)
                        .padding()
                    Spacer()
                }
                
                
                List {
                    ForEach(viewModel.categories, id: \.self) { category in
                        Text(category)
                        /* TODO: Add Edit option to category name */
//                            .swipeActions(edge: .trailing) {
//                                Button {
//
//                                } label: {
//                                    Text("Edit")
//                                }
//                                .tint(.blue)
//                            }
                    }
                    .onDelete { index in
                        guard let index = index.first else {return}
                        viewModel.categories.remove(at: index)
                        viewModel.saveCategories()
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Add category:")
            
            List(viewModel.categories, id: \.self) { category in
                Text(category)
            }
        }
    }
}
//struct CategoriesView_Previews: PreviewProvider {
//    static var previews: some View {
//        CategoriesView()
//    }
//}

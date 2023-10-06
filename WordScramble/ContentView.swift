//
//  ContentView.swift
//  WordScramble
//
//  Created by Godwin IE on 01/10/2023.
//

import SwiftUI

struct ContentView: View {
    @State public var usedWords = [String]()
    @State public var rootWord = ""
    @State public var newWord = ""
        
    var body: some View {
        NavigationView {
        List {
            Section {
                TextField("Enter your word", text: $newWord)
                    .autocapitalization(.none)
            }
            
            Section {
                ForEach (usedWords, id: \.self) {word in
                    HStack {
                        Image(systemName: "\(word.count).circle.fill")
                        Text(word)
                    }
                }
            }
           
            } //List
        } //Navigation view
        .navigationTitle(rootWord)
        .onSubmit (addNewWord)
    } //body
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard answer.count > 0 else {return}
        
        //extra validations to come
        
        withAnimation {
            usedWords.insert(answer, at: 0)
        }
        newWord = ""
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

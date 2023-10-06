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
            .navigationTitle(rootWord)
            .onSubmit (addNewWord)
            .onAppear(perform: startGame)
        } //Navigation view
        
    } //body
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard answer.count > 0 else {return}
        
        //extra validations to come
        
        withAnimation {
            usedWords.insert(answer, at: 0)
        }
        newWord = ""
    } //addnewNumber func
    
    func startGame() {
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                let allWords = startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "Silkworm"
                return
            }
        } //urnwraping words
        
        fatalError("Could not load start.txt from bundle")
    } //startGame func
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

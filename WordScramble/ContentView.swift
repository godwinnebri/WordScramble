//
//  ContentView.swift
//  WordScramble
//
//  Created by Godwin IE on 01/10/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
        
    var body: some View {
        NavigationView {
                VStack {
                    Form {
                        Section {
                            TextField("Enter your word", text: $newWord)
                                .autocapitalization(.none)
                                .autocorrectionDisabled()
                            //.textFieldStyle(RoundedBorderTextFieldStyle())
                            
                        }
                        
                        Section {
                            ForEach (usedWords, id: \.self) {word in
                                HStack {
                                    Image(systemName: "\(word.count).circle.fill")
                                    Text(word)
                                }
                            }
                        }
                    }
                    
                    Text("Words scrambled: \(usedWords.count)")
                        .foregroundColor(.green)
                    
                    Color.clear
                        .frame(height: 4)

                }//Hstack
                .navigationBarTitle (rootWord, displayMode: .large)
                .onSubmit (addNewWord)
                .onAppear(perform: startGame)
                .alert(errorTitle, isPresented: $showingError) {
                    Button ("OK", role: .cancel) {}
                } message: {
                    Text (errorMessage)
                }
                .toolbar{
                    Button("New word", action: resetWord)
                }
            
        } //Navigation view
        
    } //body
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard answer.count > 0 else {return}
        
        
        guard isShort(word: answer) else {
            wordError(title: "Word is too short", message: "Enter a word with at least three characters")
            return
        }
        
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original")
            return
        }
        
        guard isPossible(word: answer) else {
            wordError(title: "Word not possible", message: "You can't spell that word from '\(rootWord)'!")
            return
        }
        
        guard isReal(word: answer) else {
            wordError(title: "Word doesn't exist", message: "You know you just can't make words up right 🙄")
            return
        }
        
        guard isRootWord(word: answer) else {
            wordError(title: "Word is root word", message: "Your answer cannot be \(rootWord)")
            return
        }
        
        
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
    
    func isOriginal(word : String) -> Bool {
        !usedWords.contains(word)
    } // ioOriginal funnction
    
    func isPossible (word : String) -> Bool {
        var tempWord = rootWord
        
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        return true
    } //isPossible func
    
    func isReal (word : String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    } //isReal func
    
    func isShort (word : String) -> Bool {
        if word.count < 3{
            return false
        }else {
            return true
        }
    } //isShort func
    
    func isRootWord (word: String) -> Bool {
        if word == rootWord {
            return false
        } else {
            return true
        }
    } //isRootword func
    
    func resetWord() {
        startGame()
        usedWords.removeAll()
    }
    
    
    func wordError (title : String, message : String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    } //word Error
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

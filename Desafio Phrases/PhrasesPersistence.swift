//
//  PhrasesPersistence.swift
//  Desafio Phrases
//
//  Created by Luciano Almeida on 2/13/16.
//  Copyright © 2016 Luciano Almeida. All rights reserved.
//

import UIKit
import CoreData
class PhrasesPersistence: NSObject {
    var context : NSManagedObjectContext = AppCoreDataContext.sharedContext().managedContext
    
    var allPhrases: [String] {
        if let allWrapped = self.allWrappedPhrases() {
            return self.unwrappPhrases(allWrapped)
        }
        return []
    }
    
    func addPhrase(phrase: String) -> Bool{
        let phraseWrapper = NSEntityDescription.insertNewObjectForEntityForName("Phrase", inManagedObjectContext: self.context) as! Phrase
        phraseWrapper.text = phrase
        do{
            try self.context.save()
            return true
        }catch {
            return false
        }
    }
    
    func removePhrase(phrase: String) {
        if let phraseWrapper = self.findWrapperObject(phrase) {
            self.context.deleteObject(phraseWrapper)
        }
    }
    
    func contains(phrase: String) -> Bool {
        return self.findWrapperObject(phrase) != nil
    }
    
    private func findWrapperObject(phrase: String) -> Phrase?{
        let fetchRequest = NSFetchRequest(entityName: "Phrase")
        fetchRequest.predicate = NSPredicate(format: "SELF.text = %@", phrase)
        do{
            if let result = try self.context.executeFetchRequest(fetchRequest) as? [Phrase] {
                if !result.isEmpty {
                    return result[0]
                }
            }
            return nil
        }catch let error {
            print("error: \(error)")
            return nil
        }
    }
    
    private func allWrappedPhrases() -> [Phrase]? {
        let fetchRequest = NSFetchRequest(entityName: "Phrase")
        do{
            if let result = try self.context.executeFetchRequest(fetchRequest) as? [Phrase]{
                return result
            }
            return []
        }catch {
            return nil
        }
    }
    
    private func unwrappPhrases(phrases: [Phrase]) -> [String]{
        var result : [String] = []
        for phrase in phrases {
            result.append(phrase.text!)
        }
        return result
    }
}

//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class Company {
    var ceo:CEO?
    var prodManager:ProductManager?
    var dev:[Developer?] = []
    
    init() {
        ceo = CEO(array: ["Okay","Nope","What for?"], str:"Kanye")
        prodManager = ProductManager(array: ["Fine","Not now","What for?"], str: "Sam")
        dev.append(Developer(id: dev.count, array: ["Hello","What's wrong?","Missing deadline, again?","Okay"], str:"Kim"))
        dev.append(Developer(id: dev.count, array: ["Hi","I've sent pull-request","Sorry","Need your comments about my code", "Thank you"], str:"Ari"))
        
        ceo?.manager = prodManager
        for i in 0...(dev.count-1){
                if let man = prodManager{
                    if let developer = dev[i]{developer.manager = man; man.dev.append(developer)}
                }
            }
        prodManager?.ceo = ceo
    }
    
    class Employee{
        var name: String
        var msgInd: Int
        var arr: [String] = []

        init(array: [String], str:String) {
            arr = array
            name = str
            msgInd = 0
        }
        
        func answer(str:String){
            if msgInd >= arr.count {
                msgInd = 0
            }
            msgInd += 1
            print("\(String(describing: type(of: self))): \(arr[msgInd - 1])")
        }
    }
    
    class CEO : Employee {
        weak var manager: ProductManager?
        
        var printManager: () -> () {return{if let prodManager = self.manager{print("Product Manager - \(prodManager.name)")}}}
        
        var printDevelopers: () -> () {return{if let prodManager = self.manager{prodManager.printDev()}}}
        
        var printAll: () -> () {return{if let prodManager = self.manager{prodManager.printAll()}}}
        
        deinit {
            print("CEO deinit")
        }
    }
    
    class ProductManager: Employee {
        var ceo: CEO?
        var dev: [Developer?] = []
        
        var printDev: () -> () {return{
                for i in 0...(self.dev.count-1){
                    if let developer = self.dev[i]{ print("Developer\(developer.id) - \(developer.name)")}
                }
            }
        }
        
        var printAll: () -> () {return{
            if let newCEO = self.ceo{print("CEO - \(newCEO.name)"); newCEO.printManager()}
            self.printDev()
            }
        }
        
        func send(idFrom:Int, idTo:Int, msg:String){
            var i = 0
            
            while let developer = dev[i]{
                if idTo == developer.id {
                    break
                }
                if idTo >= dev.count{
                    print("There isn't such dev")
                    return
                }
                i += 1
            }
            dev[i]?.receive(idFrom: idFrom, msg: msg)
        }
        
        func devAsk(str:String, idFrom:Int, isCEO: Bool){
            if isCEO {
                print("Developer\(idFrom): \(str)")
                if let newCEO = ceo{newCEO.answer(str: str)}
            }else{
                print("Developer\(idFrom): \(str)")
                answer(str: str)
            }
        }
        
        deinit {
            print("ProductManager deinit")
        }
    }
    
    class Developer: Employee {
        weak var manager: ProductManager?
        var id: Int
        
        init(id: Int,array:[String], str:String){
            self.id = id
            super.init(array: array, str: str)
        }
        
        func send(idTo:Int){
            if msgInd < arr.count {
                msgInd+=1
                manager?.send(idFrom: self.id, idTo: idTo, msg: arr[msgInd - 1])
            }else{
                print("End of dialog")
            }
        }
        
        func askProdManager(str:String, isCEO:Bool){
            if let man = manager{man.devAsk(str: str, idFrom: id, isCEO: isCEO)}
        }

        func receive(idFrom:Int, msg:String){
            print("Developer\(idFrom): \(msg)")
            send(idTo: idFrom)
        }
        
        deinit {
            print("Developer deinit")
        }
    }
}

func boo(){
    let company = Company()
    company.ceo?.printManager()
    company.ceo?.printDevelopers()
    company.ceo?.printAll()
    company.dev[0]?.send(idTo: 1)
    company.dev[0]?.askProdManager(str: "Need pay raised", isCEO: true)
    company.dev[0]?.askProdManager(str: "Need day off", isCEO: true)
    company.dev[1]?.askProdManager(str: "I need work", isCEO: false)
    company.dev[1]?.askProdManager(str: "Don't understand task", isCEO: false)
}

boo()

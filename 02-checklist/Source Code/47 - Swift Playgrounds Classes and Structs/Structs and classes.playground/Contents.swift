class CatClass {
  var name: String
  var weight: Double  // In kilograms, just to be
                      // be scientific or international
                      // (take your pick)

  init(name: String, weight: Double) {
    self.name = name
    self.weight = weight
  }

  func report() {
    print("\(name) weighs \(weight) kilograms.")
  }

  func fatten() {
    print("Fattening \(name)...")
    weight += 0.5
    report()
  }
}

var classCat1 = CatClass(name: "Anastasia", weight: 2.5)
let classCat2 = CatClass(name: "Bao", weight: 6.3)
classCat1.report()
classCat2.report()

classCat1 = CatClass(name: "Cuddles", weight: 8.0)
classCat1.report()

//classCat2 = CatClass(name: "Dmitry", weight: 4.7)

classCat1.name = "Esmerelda"
classCat1.fatten()

classCat2.name = "Faiza"
classCat2.fatten()

var classCat3 = CatClass(name: "Imelda", weight: 6.1)
var classCat4 = CatClass(name: "Jasmine", weight: 2.2)
classCat3.report()
classCat4.report()

classCat4 = classCat3
classCat3.report()
classCat4.report()

classCat3.name = "Kenji"
classCat3.report()
classCat4.report()

classCat4.fatten()
classCat3.report()
classCat4.report()

class RoboCat: CatClass {
  var laserEnergy: Int

  init(name: String, weight: Double, laserEnergy: Int) {
    self.laserEnergy = laserEnergy
    super.init(name: name, weight: weight)
  }

  func fireLaser() {
    if laserEnergy > 0 {
      print("\(name) fires a laser. Pew! Pew!")
      laserEnergy -= 1
    } else {
      print("No energy to fire laser.")
    }
  }

  override func report() {
    print("\(name) weighs \(weight) kilograms and has \(laserEnergy) units of laser energy.")
  }
}

let classCat5 = RoboCat(name: "FELINE SECURITY UNIT", weight: 20.0, laserEnergy: 10)
classCat5.fireLaser()
classCat5.fatten()

struct CatStruct {
  var name: String
  var weight: Double  // In kilograms, just to be
                      // be scientific or international
                      // (take your pick)

  func report() {
    print("\(name) weighs \(weight) kilograms.")
  }

  mutating func fatten() {
    print("Fattening \(name)...")
    weight += 0.5
    report()
  }
}

var structCat1 = CatStruct(name: "Latifah", weight: 3.9)
structCat1.name = "Mongo"
structCat1.weight = 10.0 // Mongo likes candy!
structCat1.report()

structCat1.weight += 0.5
structCat1.report()

structCat1.fatten()

var structCat2 = structCat1
structCat2.report()
structCat2.name = "Naveen"
structCat2.weight = 5.3
structCat1.report()
structCat2.report()

//let structCat3 = CatStruct(name: "Orson", weight: 5.5)
//structCat3.fatten()

protocol Pet {
  var name: String { get set }
  var weight: Double { get set }

  func report() -> ()
  mutating func fatten() -> ()
}

struct ProtocolCat: Pet {
  var name: String
  var weight: Double
}

extension Pet {
  func report() {
    print("\(name) weighs \(weight) kilograms.")
  }

  mutating func fatten() {
    print("Fattening \(name)...")
    weight += 0.5
    report()
  }
}

var structCat4 = ProtocolCat(name: "Pasquale", weight: 7.7)
structCat4.report()
structCat4.fatten()

struct Dog: Pet {
  var name: String
  var weight: Double

  func fetch() {
    print("You throw a ball, and \(name) gets it and brings it back to you.")
  }
}

var myDog = Dog(name: "Quincy", weight: 9.4)
myDog.report()
myDog.fatten()
myDog.fetch()

protocol LaserEquipped {
  var laserEnergy: Int { get set }

  mutating func fireLaser() -> ()
}

extension LaserEquipped {
  mutating func fireLaser() {
    if laserEnergy > 0 {
      print("Firing laser. Pew! Pew!")
      laserEnergy -= 1
    } else {
      print("No energy to fire laser.")
    }
  }
}

struct LaserCat: Pet, LaserEquipped {
  var name: String
  var weight: Double
  var laserEnergy: Int
}

var laserKitty = LaserCat(name: "Renoir", weight: 20.0, laserEnergy: 20)
laserKitty.report()
laserKitty.fatten()
laserKitty.fireLaser()

struct LaserDog: Pet, LaserEquipped {
  var name: String
  var weight: Double
  var laserEnergy: Int

  func fetch() {
    print("You throw a ball, and \(name) gets it and brings it back to you.")
  }
}

var laserPuppy = LaserDog(name: "Salieri", weight: 20.0, laserEnergy: 20)
laserPuppy.report()
laserPuppy.fatten()
laserPuppy.fireLaser()
laserPuppy.fetch()

struct Hamster: Pet {
  var name: String
  var weight: Double
  var isOnHamsterWheel: Bool

  func report() {
    let wheelStatus = isOnHamsterWheel ? "on" : "not on"
    print("\(name) weighs \(weight) kilograms, and is \(wheelStatus) its hamster wheel.")
  }
}

var myHamster = Hamster(name: "Tetsuo", weight: 0.1, isOnHamsterWheel: true)
myHamster.report()

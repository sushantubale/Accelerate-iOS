//
//  Model.swift
//  CloudKit-iOS
//
//  Created by Sushant Ubale on 8/12/24.
//

import Foundation
import CloudKit

class Model {
    // MARK: - iCloud Info
    let container: CKContainer
    let publicDB: CKDatabase
    let privateDB: CKDatabase
    
    // MARK: - Properties
    private(set) var establishments: [Establishment] = []
    static var currentModel = Model()
    
    init() {
      container = CKContainer.default()
      publicDB = container.publicCloudDatabase
      privateDB = container.privateCloudDatabase
    }
    
    @objc func refresh(_ completion: @escaping (Error?) -> Void) {
      let predicate = NSPredicate(value: true)
      let query = CKQuery(recordType: "Establishment", predicate: predicate)
      establishments(forQuery: query, completion)
    }

    
    private func establishments(forQuery query: CKQuery, _ completion: @escaping (Error?) -> Void) {
      publicDB.perform(query, inZoneWith: CKRecordZone.default().zoneID) { [weak self] results, error in
        guard let self = self else { return }
        if let error = error {
          DispatchQueue.main.async {
            completion(error)
          }
          return
        }
        guard let results = results else { return }
        self.establishments = results.compactMap {
          Establishment(record: $0, database: self.publicDB)
        }
        DispatchQueue.main.async {
          completion(nil)
        }
      }
    }
  }

import MapKit
import CloudKit
import CoreLocation

class Establishment {
  enum ChangingTable: Int {
    case none
    case womens
    case mens
    case both
  }
  
  static let recordType = "Establishment"
  private let id: CKRecord.ID
  let name: String
  let location: CLLocation
  let coverPhoto: CKAsset?
  let database: CKDatabase
  let changingTable: ChangingTable
  let kidsMenu: Bool
  let healthyOption: Bool
  private(set) var notes: [Note]? = nil
  
  init?(record: CKRecord, database: CKDatabase) {
    guard
      let name = record["name"] as? String,
      let location = record["location"] as? CLLocation
      else { return nil }
    id = record.recordID
    self.name = name
    self.location = location
    coverPhoto = record["coverPhoto"] as? CKAsset
    self.database = database
    healthyOption = record["healthyOption"] as? Bool ?? false
    kidsMenu = record["kidsMenu"] as? Bool ?? false
    if let changingTableValue = record["changingTable"] as? Int,
      let changingTable = ChangingTable(rawValue: changingTableValue) {
      self.changingTable = changingTable
    } else {
      self.changingTable = .none
    }
    if let noteRecords = record["notes"] as? [CKRecord.Reference] {
      Note.fetchNotes(for: noteRecords) { notes in
        self.notes = notes
      }
    }
  }
  
  func loadCoverPhoto(completion: @escaping (_ photo: UIImage?) -> ()) {
    DispatchQueue.global(qos: .utility).async {
      var image: UIImage?
      defer {
        DispatchQueue.main.async {
          completion(image)
        }
      }
      guard
        let coverPhoto = self.coverPhoto,
        let fileURL = coverPhoto.fileURL
        else {
          return
      }
      let imageData: Data
      do {
        imageData = try Data(contentsOf: fileURL)
      } catch {
        return
      }
      image = UIImage(data: imageData)
    }
  }
}

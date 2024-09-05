//
//  GetCorpCodesAPI.swift
//  Public-Corporation-List
//
//  Created by sohyeon on 7/11/24.
//

import Foundation
import ZIPFoundation

/**
 [GET] https://opendart.fss.or.kr/api/corpCode.xml
 */

class GetCorporationAPI {
    static let shared = GetCorporationAPI()
    
    private let API_KEY = "c0fa19277697e815963b4fd6c31bbb17d08f071c"
    private let GET_COMPANY_URI = "https://opendart.fss.or.kr/api/corpCode.xml"
}

extension GetCorporationAPI {
    
    func fetchCompanies() async throws -> [CorporationInfo] {
        let fileManager = FileManager.default
        let tempZipFileURL = fileManager.temporaryDirectory.appendingPathComponent("corp_code.zip")
        let tempUnzipDirectoryURL = fileManager.temporaryDirectory.appendingPathComponent("unzip")
        
        // XML 파일 존재
        if fileManager.fileExists(atPath: tempUnzipDirectoryURL.path) {
          return try await parseXMLFromDirectory(at: tempUnzipDirectoryURL)
        }

        // ZIP 파일 존재
        if fileManager.fileExists(atPath: tempZipFileURL.path) {
          try fileManager.createDirectory(at: tempUnzipDirectoryURL, withIntermediateDirectories: true, attributes: nil)
          try fileManager.unzipItem(at: tempZipFileURL, to: tempUnzipDirectoryURL)
          return try await parseXMLFromDirectory(at: tempUnzipDirectoryURL)
        }

        // API 호출 (xml 다운로드)
        guard let url = URL(string: "\(GET_COMPANY_URI)?crtfc_key=\(API_KEY)") else {
          throw NSError(domain: "Invalid URL", code: -1, userInfo: nil)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        try data.write(to: tempZipFileURL)
        try fileManager.createDirectory(at: tempUnzipDirectoryURL, withIntermediateDirectories: true, attributes: nil)
        try fileManager.unzipItem(at: tempZipFileURL, to: tempUnzipDirectoryURL)
        
        return try await parseXMLFromDirectory(at: tempUnzipDirectoryURL)
    }

    func parseXMLFromDirectory(at directoryURL: URL) async throws -> [CorporationInfo] {
        let fileManager = FileManager.default
        let xmlFiles = try fileManager.contentsOfDirectory(at: directoryURL, includingPropertiesForKeys: nil)
            .filter { $0.pathExtension == "xml" }
          
        guard let xmlFileURL = xmlFiles.first else {
            throw NSError(domain: "No existed XML file", code: -1, userInfo: nil)
        }

        let xmlData = try Data(contentsOf: xmlFileURL)
        
        return CorporationInfoParser().parse(data: xmlData)
    }
}

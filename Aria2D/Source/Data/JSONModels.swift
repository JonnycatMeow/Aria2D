//
//  JSONModels.swift
//  Aria2D
//
//  Created by xjbeta on 2017/7/10.
//  Copyright © 2017年 xjbeta. All rights reserved.
//

import Foundation

struct PCSErrno: Decodable {
	let errno: Int
}

class PCSError: Decodable {
	var errorCode: Int?
	var errorMsg: String?
	var isError = false
	
	private enum CodingKeys: String, CodingKey {
		case errorCode = "error_code"
		case errorMsg = "error_msg "
	}
	
	required convenience init(from decoder: Decoder) throws {
		self.init()
		let container = try decoder.container(keyedBy: CodingKeys.self)
		errorCode = try container.decodeIfPresent(Int.self, forKey: .errorCode)
		errorMsg = try container.decodeIfPresent(String.self, forKey: .errorMsg)
		isError = errorCode != nil
	}
}

struct PCSInfo: Decodable {
    var quota: Double
    var used: Double
}

/*
struct PCSFile: Codable {
	let category: Int
	let unlist: Int
	let fsID: Int
	let isdir: Bool
	let localCtime: Int
	let localMtime: Int
	let operID: Int
	let path: String
	let serverCtime: Int
	let serverFilename: String
	let serverMtime: Int
	let size: Int

	private enum CodingKeys : String, CodingKey {
		case category,
		unlist,
		fsID = "fs_id",
		isdir,
		localCtime = "local_ctime",
		localMtime = "local_mtime",
		operID = "oper_id",
		path,
		serverCtime = "server_ctime",
		serverFilename = "server_filename",
		serverMtime = "server_mtime",
		size
	}
}
*/

struct PCSFileList: Decodable {
	let errno: Int
	let list: [PCSFile]
}

struct JSONRPC: Decodable {
	let jsonrpc: String
//	let method: String
//	var params: Data
	let id: String
}


struct JSONNotice: Decodable {
	struct GID: Decodable {
		let gid: String
	}
	let jsonrpc: String
	let method: Aria2Notice
	let params: [GID]
}

/*
struct Aria2Object: Codable {
	let files: [Aria2File]
	
	let gid: String
	let status: Status
	let totalLength: Int64
	let completedLength: Int64
	let uploadLength: Int64
	let downloadSpeed: Int64
	let pieceLength: Int64
	let connections: Int
	let dir: String
	
//	let bitfield: String
//	let uploadSpeed: String
//	let infoHash: String
//	let numSeeders: String
//	let seeder: Bool
//	let numPieces: String
//	let errorCode: String
//	let errorMessage: String
//	let followedBy: String
//	let following: String
//	let belongsTo: String
//	let files: String
//	let bittorrent: String
//	let verifiedLength: String
//	let verifyIntegrityPending: String
	
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		files = try values.decode([Aria2File].self, forKey: .files)
		gid = try values.decode(String.self, forKey: .gid)
		status = Status(try values.decode(String.self, forKey: .status)) ?? .error
		totalLength = Int64(try values.decode(String.self, forKey: .totalLength)) ?? 0
		completedLength = Int64(try values.decode(String.self, forKey: .completedLength)) ?? 0
		uploadLength = Int64(try values.decode(String.self, forKey: .uploadLength)) ?? 0
		downloadSpeed = Int64(try values.decode(String.self, forKey: .downloadSpeed)) ?? 0
		pieceLength = Int64(try values.decode(String.self, forKey: .pieceLength)) ?? 0
		connections = Int(try values.decode(String.self, forKey: .connections)) ?? 0
		dir = try values.decode(String.self, forKey: .dir)
	}
}
*/

struct Aria2Status: Decodable {
	let gid: String
	let status: Status
	let totalLength: Int64
	let completedLength: Int64
	let uploadLength: Int64
	let downloadSpeed: Int64
	let connections: Int
	let bittorrent: Bittorrent?
	let dir: String?
	
	private enum CodingKeys: String, CodingKey {
		case gid,
		status,
		totalLength,
		completedLength,
		uploadLength,
		downloadSpeed,
		connections,
		bittorrent,
		dir
	}
	
	
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		gid = try values.decode(String.self, forKey: .gid)
		status = Status(try values.decode(String.self, forKey: .status)) ?? .error
		totalLength = Int64(try values.decode(String.self, forKey: .totalLength)) ?? 0
		completedLength = Int64(try values.decode(String.self, forKey: .completedLength)) ?? 0
		uploadLength = Int64(try values.decode(String.self, forKey: .uploadLength)) ?? 0
		downloadSpeed = Int64(try values.decode(String.self, forKey: .downloadSpeed)) ?? 0
		connections = Int(try values.decode(String.self, forKey: .connections)) ?? 0
		bittorrent = try values.decodeIfPresent(Bittorrent.self, forKey: .bittorrent)
		dir = try values.decodeIfPresent(String.self, forKey: .dir)
	}
	
	func dic() -> [String: Any] {
		var dic: [String: Any] = [:]
		dic["gid"] = gid
		dic["status"] = status.rawValue
		dic["totalLength"] = totalLength
		dic["completedLength"] = completedLength
		dic["uploadLength"] = uploadLength
		dic["downloadSpeed"] = downloadSpeed
		dic["connections"] = connections
		dic["bittorrent"] = bittorrent
		dic["dir"] = dir
//		dic["date"] = Date().timeIntervalSince1970
		return dic
	}
	
	
}


struct ErrorResult: Decodable {
	let code: Int
	let message: String
}


// getGlobalOption
public struct Aria2Version: Decodable {
	let enabledFeatures: [String]
	let version: String
}


struct OptionResult: Decodable {
	var result: [Aria2Option: String]
	private enum CodingKeys: String, CodingKey {
		case result
	}
	
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		let dic = try values.decode([String: String].self, forKey: .result)
		result = dic.reduce([Aria2Option: String]()) { result, dic in
			var re = result
			re[Aria2Option(rawValue: dic.key)] = dic.value
			return re
		}
	}
}

@objc(Aria2Peer)
class Aria2Peer: NSObject, Decodable {
    @objc dynamic let peerId: String
    let ip: String
    let port: Int
    let amChoking: Bool
    let peerChoking: Bool
    @objc dynamic let downloadSpeed: Int64
    @objc dynamic let uploadSpeed: Int64
    let seeder: Bool
    
    @objc dynamic let ipWithPort: String
    
    private enum CodingKeys: String, CodingKey {
        case peerId,
        ip,
        port,
        amChoking,
        peerChoking,
        downloadSpeed,
        uploadSpeed,
        seeder
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        peerId = try values.decode(String.self, forKey: .peerId)
        ip = try values.decode(String.self, forKey: .ip)
        port = Int(try values.decode(String.self, forKey: .port)) ?? 0
        amChoking = try values.decode(String.self, forKey: .amChoking) == "true"
        peerChoking = try values.decode(String.self, forKey: .peerChoking) == "true"
        downloadSpeed = Int64(try values.decode(String.self, forKey: .downloadSpeed)) ?? 0
        uploadSpeed = Int64(try values.decode(String.self, forKey: .uploadSpeed)) ?? 0
        seeder = try values.decode(String.self, forKey: .seeder) == "true"
        ipWithPort = ip + ":" + "\(port)"
    }
}

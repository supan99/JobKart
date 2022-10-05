//
//  UserModel.swift
//  JobKart


import Foundation


class UserModel {
    var docID: String
    var name: String
    var mobile: String
    var organizationType: String
    var email: String
    var password: String
    var userType: String
    
    init(docID: String,name: String,mobile: String,email: String, password:String, organizationType: String,userType: String){
        self.docID = docID
        self.name = name
        self.email = email
        self.mobile = mobile
        self.password = password
        self.organizationType = organizationType
        self.userType = userType
    }
}


class UserDataModel {
    var docID: String
    var name: String
    var mobile: String
    var organizationType: String
    var email: String
    var password: String
    var userType: String
    var orgAddress: String
    var orgName: String
    var eduLevel: String
    var skills: String
    var orgImageURL: String
    var aboutMe: String
    var isBlock: Bool
    var exp: String
    
    init(docID: String,name: String,mobile: String,email: String, password:String, organizationType: String,userType: String, orgAddress: String, orgName: String, eduLevel: String, skills: String, orgImageURL: String, aboutMe: String, isBlock: Bool,exp : String){
        self.docID = docID
        self.name = name
        self.email = email
        self.mobile = mobile
        self.password = password
        self.organizationType = organizationType
        self.userType = userType
        self.orgAddress = orgAddress
        self.eduLevel = eduLevel
        self.skills = skills
        self.orgName = orgName
        self.orgImageURL = orgImageURL
        self.aboutMe = aboutMe
        self.isBlock = isBlock
        self.exp = exp
    }
}

//
//  PostModel.swift
//  JobKart


import Foundation


class PostModel {
    var docID: String
    var job_address: String
    var job_name: String
    var job_oType: String
    var job_email: String
    var address: String
    var job_salary: String
    var description: String
    var requirement: String
    var user_email: String
    var user_phone: String
    var uid: String
    var favID: String
    var saveAndApply: [[String:Any]]
    
    init(docId: String, job_address: String, job_name : String, job_oType: String, job_email: String, address: String, job_salary : String, description : String, requirement : String, user_email : String, user_Phone : String, uid: String, favID: String, saveAndApply: [[String:Any]]){
        self.job_name = job_name
        self.job_address = job_address
        self.job_oType = job_oType
        self.job_email = job_email
        self.address = address
        self.description = description
        self.job_salary = job_salary
        self.requirement = requirement
        self.user_email = user_email
        self.user_phone = user_Phone
        self.docID = docId
        self.uid = uid
        self.favID = favID
        self.saveAndApply = saveAndApply
    }
}

class SavedPostModel {
    var docID: String
    var jEmpEmail: String
    var jPhone: String
    var jIsApproved: Bool
    var jJobDescription: String
    var jJobID: String
    var jLocation: String
    var jPostName: String
    var jJSAboutMe: String
    var jJSAddress: String
    var jsEmail: String
    var jJSExp: String
    var jJSImageURL: String
    var jJSName: String
    var jJSPhone: String
    var jSkills: String
    var jOrgAddress: String
    var jOrgType: String
    var jJobSalary: String
    var jRequirement: String
    var uid: String
    
    init(docId: String, jEmpEmail: String, jPhone : String, jIsApproved: Bool, jJobDescription: String, jJobID: String, jLocation : String, jPostName : String, jJSAboutMe : String, jJSAddress : String, jsEmail : String,jJSExp: String,jJSImageURL: String, jJSName: String,jJSPhone:String,jSkills: String, jOrgAddress: String,jOrgType: String,jJobSalary: String, jRequirement: String, uid: String){
        self.jPhone = jPhone
        self.jEmpEmail = jEmpEmail
        self.jIsApproved = jIsApproved
        self.jJobDescription = jJobDescription
        self.jJobID = jJobID
        self.jLocation = jLocation
        self.jPostName = jPostName
        self.jJSAboutMe = jJSAboutMe
        self.jJSAddress = jJSAddress
        self.jsEmail = jsEmail
        self.jJSExp =  jJSExp
        self.jJSImageURL = jJSImageURL
        self.jJSName = jJSName
        self.jJSPhone = jJSPhone
        self.jSkills = jSkills
        self.jOrgAddress = jOrgAddress
        self.jOrgType = jOrgType
        self.jJobSalary = jJobSalary
        self.jRequirement = jRequirement
        self.docID = docId
        self.uid = uid
    }
}

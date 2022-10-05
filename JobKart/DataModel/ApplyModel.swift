//
//  ApplyModel.swift
//  JobKart

import Foundation


class ApplyModel {
    var docID: String
    var empName: String
    var empPhone: String
    var empEmail: String
    var isApproved: Bool
    var isRejected: Bool
    var jobName: String
    var jobRequirements: String
    var jobOtype: String
    var job_aboutme: String
    var job_Skills: String
    var salary: String
    var address: String
    var job_address: String
    var uid: String
    var jobID: String
    var jobDescription: String
    var exp: String
    
    init(docId: String, empName: String, empPhone: String, empEmail: String, isApproved: Bool, isRejected: Bool, jobName: String,jobRequirements: String, jobOtype: String, job_aboutme: String,job_Skills: String, salary: String, address: String, job_address: String, uid: String, jobID: String, jobDescription: String,exp: String){
        self.docID = docId
        self.empName = empName
        self.empPhone = empPhone
        self.empEmail = empEmail
        self.isApproved = isApproved
        self.isRejected = isRejected
        self.jobName = jobName
        self.jobRequirements = jobRequirements
        self.jobOtype = jobOtype
        self.job_address = job_address
        self.job_aboutme = job_aboutme
        self.job_Skills = job_Skills
        self.address = address
        self.salary = salary
        self.uid = uid
        self.jobID = jobID
        self.jobDescription = jobDescription
        self.exp = exp
    }
}

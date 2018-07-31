//
//  SampleData.swift
//  Headspace
//
//  Created by Justin Wells on 7/24/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import Foundation
import Firebase

private var ref = Database.database().reference()

func uploadPacks(){
    //Packs Data Array
    var packsDataArray = [Dictionary<String, Any>]()
    
    //Create Packs Data
    let ref = Database.database().reference()
    for i in stride(from: 0, to: packsNames.count, by: 1) {
        var packsData = Dictionary<String, Any>()
        packsData["objectId"] = ref.childByAutoId().key
        packsData["createdAt"] = ServerValue.timestamp()
        packsData["updatedAt"] = ServerValue.timestamp()
        packsData["name"] = packsNames[i]
        //packsData["image"] = packsImages[i]
        packsData["coverImage"] = packsCoverImages[i]
        packsData["category"] = packsCategories[i]
        packsData["sessions"] = packsSessions[i]
        packsData["sessionLengths"] = packsSessionLengths[i]
        packsData["techniques"] = packsTechniques[i]
        packsData["details"] = packsDetails[i]
        packsData["audio"] = packsAudio[i]
        packsData["isPremium"] = packsIsPremium[i]
        packsDataArray.append(packsData)
    }
    
    for i in stride(from: 0, to: imageNames.count, by: 1) {
        //Convert Image to Data
        let imageData = UIImageJPEGRepresentation(UIImage(named: imageNames[i])!, 0.7)
        //Save Item Image
        let imageFileName = String(format: "%@Image.jpeg", imageNames[i])
        let storageRef = Storage.storage().reference()
        _ = storageRef.child(packsDatabase).child(imageNames[i]).child(imageFileName).putData(imageData!, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
            }
            // Metadata contains file metadata such as size, content-type, and download URL.
            let downloadURL: URL = metadata.downloadURL()!
            print(downloadURL.absoluteString)
            
            //Upload Packs to Database
            var packsData = packsDataArray[i]
            packsData["image"] = downloadURL.absoluteString
            ref.child(packsDatabase).child(packsData["objectId"] as! String).setValue(packsData) { (error:Error?, DatabaseReference) in
                if((error) != nil){
                    print("Error uploading pack")
                }
            }
        }
    }
}

//Packs Raw Data
let packsNames = ["Basics", "Basics 2", "Basics 3", "Mindful Eating", "Managing Anxiety", "Stress", "Sleep", "Pregnancy", "Coping with Cancer", "Pain management", "Sadness", "Grief", "Regret", "Anger", "Change", "Restlessness", "Self-esteem", "Relationships", "Patience", "Happiness", "Acceptance", "Appreciation", "Kindness", "Generosity", "Prioritization", "Productivity", "Finding Focus", "Creativity", "Balance", "Leaving Home", "Distractions", "Level 1", "Level 2", "Level 3", "Level 4", "Level 5", "Level 6", "Motivation", "Concentration", "Training", "Competition", "Communication", "Analysis", "Recovery", "Rehab"]
let packsImages = ["", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""]
let packsCoverImages = ["https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSPacks%2FCoverImages%2FfoundationCoverImage.jpeg?alt=media&token=ea50da38-f7c3-45b2-9889-1d05de041b1c", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSPacks%2FCoverImages%2FfoundationCoverImage.jpeg?alt=media&token=ea50da38-f7c3-45b2-9889-1d05de041b1c", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSPacks%2FCoverImages%2FfoundationCoverImage.jpeg?alt=media&token=ea50da38-f7c3-45b2-9889-1d05de041b1c", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSPacks%2FCoverImages%2FhealthCoverImage.jpeg?alt=media&token=481e0a8e-7063-419d-840d-3072def1cafe", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSPacks%2FCoverImages%2FhealthCoverImage.jpeg?alt=media&token=481e0a8e-7063-419d-840d-3072def1cafe", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSPacks%2FCoverImages%2FhealthCoverImage.jpeg?alt=media&token=481e0a8e-7063-419d-840d-3072def1cafe", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSPacks%2FCoverImages%2FhealthCoverImage.jpeg?alt=media&token=481e0a8e-7063-419d-840d-3072def1cafe", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSPacks%2FCoverImages%2FhealthCoverImage.jpeg?alt=media&token=481e0a8e-7063-419d-840d-3072def1cafe", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSPacks%2FCoverImages%2FhealthCoverImage.jpeg?alt=media&token=481e0a8e-7063-419d-840d-3072def1cafe", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSPacks%2FCoverImages%2FhealthCoverImage.jpeg?alt=media&token=481e0a8e-7063-419d-840d-3072def1cafe", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSPacks%2FCoverImages%2FbraveCoverImage.jpeg?alt=media&token=4be7e020-d43b-40b8-a38a-439570ec2b84", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSPacks%2FCoverImages%2FbraveCoverImage.jpeg?alt=media&token=4be7e020-d43b-40b8-a38a-439570ec2b84", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSPacks%2FCoverImages%2FbraveCoverImage.jpeg?alt=media&token=4be7e020-d43b-40b8-a38a-439570ec2b84", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSPacks%2FCoverImages%2FbraveCoverImage.jpeg?alt=media&token=4be7e020-d43b-40b8-a38a-439570ec2b84", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSPacks%2FCoverImages%2FbraveCoverImage.jpeg?alt=media&token=4be7e020-d43b-40b8-a38a-439570ec2b84", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSPacks%2FCoverImages%2FbraveCoverImage.jpeg?alt=media&token=4be7e020-d43b-40b8-a38a-439570ec2b84", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSPacks%2FCoverImages%2FhappinessCoverImage.jpeg?alt=media&token=48d172a7-8256-4280-a7d9-f9210d36bc90", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSPacks%2FCoverImages%2FhappinessCoverImage.jpeg?alt=media&token=48d172a7-8256-4280-a7d9-f9210d36bc90", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSPacks%2FCoverImages%2FhappinessCoverImage.jpeg?alt=media&token=48d172a7-8256-4280-a7d9-f9210d36bc90", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSPacks%2FCoverImages%2FhappinessCoverImage.jpeg?alt=media&token=48d172a7-8256-4280-a7d9-f9210d36bc90", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSPacks%2FCoverImages%2FhappinessCoverImage.jpeg?alt=media&token=48d172a7-8256-4280-a7d9-f9210d36bc90", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSPacks%2FCoverImages%2FhappinessCoverImage.jpeg?alt=media&token=48d172a7-8256-4280-a7d9-f9210d36bc90", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSPacks%2FCoverImages%2FhappinessCoverImage.jpeg?alt=media&token=48d172a7-8256-4280-a7d9-f9210d36bc90", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSPacks%2FCoverImages%2FhappinessCoverImage.jpeg?alt=media&token=48d172a7-8256-4280-a7d9-f9210d36bc90", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSPacks%2FCoverImages%2FworkAndPerformanceCoverImage.jpeg?alt=media&token=886f34d8-01f9-410b-9438-f942e63a7d2e", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSPacks%2FCoverImages%2FworkAndPerformanceCoverImage.jpeg?alt=media&token=886f34d8-01f9-410b-9438-f942e63a7d2e", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSPacks%2FCoverImages%2FworkAndPerformanceCoverImage.jpeg?alt=media&token=886f34d8-01f9-410b-9438-f942e63a7d2e", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSPacks%2FCoverImages%2FworkAndPerformanceCoverImage.jpeg?alt=media&token=886f34d8-01f9-410b-9438-f942e63a7d2e", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSPacks%2FCoverImages%2FworkAndPerformanceCoverImage.jpeg?alt=media&token=886f34d8-01f9-410b-9438-f942e63a7d2e", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSPacks%2FCoverImages%2FstudentsCoverImage.jpeg?alt=media&token=f8d31d6c-befe-4753-be7b-7e88be65a877", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSPacks%2FCoverImages%2FstudentsCoverImage.jpeg?alt=media&token=f8d31d6c-befe-4753-be7b-7e88be65a877", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSPacks%2FCoverImages%2FheadspaceProCoverImage.jpeg?alt=media&token=f17b694c-939a-4d92-b83f-2ff0e2cf4528", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSPacks%2FCoverImages%2FheadspaceProCoverImage.jpeg?alt=media&token=f17b694c-939a-4d92-b83f-2ff0e2cf4528", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSPacks%2FCoverImages%2FheadspaceProCoverImage.jpeg?alt=media&token=f17b694c-939a-4d92-b83f-2ff0e2cf4528", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSPacks%2FCoverImages%2FheadspaceProCoverImage.jpeg?alt=media&token=f17b694c-939a-4d92-b83f-2ff0e2cf4528", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSPacks%2FCoverImages%2FheadspaceProCoverImage.jpeg?alt=media&token=f17b694c-939a-4d92-b83f-2ff0e2cf4528", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSPacks%2FCoverImages%2FheadspaceProCoverImage.jpeg?alt=media&token=f17b694c-939a-4d92-b83f-2ff0e2cf4528", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSPacks%2FCoverImages%2FsportCoverImage.jpeg?alt=media&token=653f22db-fb75-44ca-a25a-b16a44433308", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSPacks%2FCoverImages%2FsportCoverImage.jpeg?alt=media&token=653f22db-fb75-44ca-a25a-b16a44433308", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSPacks%2FCoverImages%2FsportCoverImage.jpeg?alt=media&token=653f22db-fb75-44ca-a25a-b16a44433308", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSPacks%2FCoverImages%2FsportCoverImage.jpeg?alt=media&token=653f22db-fb75-44ca-a25a-b16a44433308", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSPacks%2FCoverImages%2FsportCoverImage.jpeg?alt=media&token=653f22db-fb75-44ca-a25a-b16a44433308", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSPacks%2FCoverImages%2FsportCoverImage.jpeg?alt=media&token=653f22db-fb75-44ca-a25a-b16a44433308", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSPacks%2FCoverImages%2FsportCoverImage.jpeg?alt=media&token=653f22db-fb75-44ca-a25a-b16a44433308", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSPacks%2FCoverImages%2FsportCoverImage.jpeg?alt=media&token=653f22db-fb75-44ca-a25a-b16a44433308"]
let packsCategories = ["Foundation", "Foundation", "Foundation", "Health", "Health", "Health", "Health", "Health", "Health", "Health", "Brave", "Brave", "Brave", "Brave", "Brave", "Brave", "Happiness", "Happiness", "Happiness", "Happiness", "Happiness", "Happiness", "Happiness", "Happiness", "Work & Performance", "Work & Performance", "Work & Performance", "Work & Performance", "Work & Performance", "Students", "Students", "Headspace Pro", "Headspace Pro", "Headspace Pro", "Headspace Pro", "Headspace Pro", "Headspace Pro", "Sport", "Sport", "Sport", "Sport", "Sport", "Sport", "Sport", "Sport"]
let packsSessions = [10, 10, 10, 10, 30, 30, 30, 30, 30, 30, 30, 30, 10, 10, 10, 10, 30, 30, 10, 10, 10, 10, 10, 10, 10, 10, 30, 30, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10]
let packsSessionLengths = ["3,5,10", "3,5,10", "3,5,10", "10,15,20", "10,15,20", "10,15,20", "10,15,20", "10,15,20", "10,15,20", "10,15,20", "10,15,20", "10,15,20", "10,15,20", "10,15,20", "10,15,20", "10,15,20", "10,15,20", "10,15,20", "10,15,20", "10,15,20", "10,15,20", "10,15,20", "10,15,20", "10,15,20", "10,15,20", "10,15,20", "10,15,20", "10,15,20", "10,15,20", "10,15,20", "10,15,20", "10,15,20", "10,15,20", "10,15,20", "10,15,20", "10,15,20", "10,15,20", "10,15,20", "10,15,20", "10,15,20", "10,15,20", "10,15,20", "10,15,20", "10,15,20", "10,15,20"]
let packsTechniques = ["-LIcTY2OGuNHIrtDuI5F", "-LIcTY2OGuNHIrtDuI5F", "-LIcTY2OGuNHIrtDuI5F", "-LIcTY2OGuNHIrtDuI5F,-LIcTY2PUO2s4R3FEqfH", "-LIcTY2OGuNHIrtDuI5F,-LIcTY2PUO2s4R3FEqfH", "-LIcTY2OGuNHIrtDuI5F,-LIcTY2OGuNHIrtDuI5G", "-LIcTY2OGuNHIrtDuI5F,-LIcTY2QCdK1sMCBTL82,-LIcTY2OGuNHIrtDuI5G", "-LIcTY2OGuNHIrtDuI5F,-LIcTY2OGuNHIrtDuI5G,-LIcTY2PUO2s4R3FEqfK", "-LIcTY2OGuNHIrtDuI5F,-LIcTY2PUO2s4R3FEqfH,-LIcTY2OGuNHIrtDuI5G", "-LIcTY2OGuNHIrtDuI5F,-LIcTY2QCdK1sMCBTL83,-LIcTY2QCdK1sMCBTL82", "-LIcTY2OGuNHIrtDuI5F,-LIcTY2PUO2s4R3FEqfH,-LIcTY2OGuNHIrtDuI5G", "-LIcTY2OGuNHIrtDuI5F,-LIcTY2QCdK1sMCBTL83,-LIcTY2OGuNHIrtDuI5G,-LIcTY2PUO2s4R3FEqfJ", "-LIcTY2OGuNHIrtDuI5F,-LIcTY2PUO2s4R3FEqfH", "-LIcTY2QCdK1sMCBTL83,-LIcTY2OGuNHIrtDuI5F", "-LIcTY2OGuNHIrtDuI5F,-LIcTY2PUO2s4R3FEqfH", "-LIcTY2PUO2s4R3FEqfH,-LIcTY2OGuNHIrtDuI5F", "-LIcTY2PUO2s4R3FEqfH,-LIcTY2OGuNHIrtDuI5G,-LIcTY2QCdK1sMCBTL82", "-LIcTY2OGuNHIrtDuI5F,-LIcTY2OGuNHIrtDuI5G,-LIcTY2PUO2s4R3FEqfJ", "-LIcTY2OGuNHIrtDuI5F,-LIcTY2PUO2s4R3FEqfH", "-LIcTY2OGuNHIrtDuI5F,-LIcTY2OGuNHIrtDuI5G", "-LIcTY2OGuNHIrtDuI5F,-LIcTY2PUO2s4R3FEqfJ", "-LIcTY2OGuNHIrtDuI5F,-LIcTY2PUO2s4R3FEqfJ", "-LIcTY2OGuNHIrtDuI5F,-LIcTY2OGuNHIrtDuI5G,-LIcTY2PUO2s4R3FEqfK", "-LIcTY2OGuNHIrtDuI5F,-LIcTY2OGuNHIrtDuI5G,-LIcTY2PUO2s4R3FEqfH", "-LIcTY2OGuNHIrtDuI5F,-LIcTY2QCdK1sMCBTL83", "-LIcTY2OGuNHIrtDuI5F,-LIcTY2PUO2s4R3FEqfH", "-LIcTY2OGuNHIrtDuI5F,-LIcTY2OGuNHIrtDuI5G", "-LIcTY2OGuNHIrtDuI5F,-LIcTY2OGuNHIrtDuI5G", "-LIcTY2OGuNHIrtDuI5F,-LIcTY2OGuNHIrtDuI5G", "-LIcTY2OGuNHIrtDuI5F,-LIcTY2QCdK1sMCBTL83", "-LIcTY2OGuNHIrtDuI5F,-LIcTY2QCdK1sMCBTL83", "-LIcTY2OGuNHIrtDuI5F,-LIcTY2QCdK1sMCBTL82", "-LIcTY2OGuNHIrtDuI5F,-LIcTY2QCdK1sMCBTL82", "-LIcTY2OGuNHIrtDuI5F,-LIcTY2QCdK1sMCBTL82", "-LIcTY2OGuNHIrtDuI5F,-LIcTY2QCdK1sMCBTL82", "-LIcTY2OGuNHIrtDuI5F,-LIcTY2QCdK1sMCBTL82", "-LIcTY2OGuNHIrtDuI5F,-LIcTY2QCdK1sMCBTL82", "-LIcTY2OGuNHIrtDuI5F,-LIcTY2PUO2s4R3FEqfJ", "-LIcTY2OGuNHIrtDuI5F,-LIcTY2QCdK1sMCBTL83", "-LIcTY2OGuNHIrtDuI5F,-LIcTY2PUO2s4R3FEqfH", "-LIcTY2OGuNHIrtDuI5F,-LIcTY2QCdK1sMCBTL83", "-LIcTY2OGuNHIrtDuI5F", "-LIcTY2OGuNHIrtDuI5F,-LIcTY2QCdK1sMCBTL83", "-LIcTY2OGuNHIrtDuI5F,-LIcTY2OGuNHIrtDuI5G", "-LIcTY2OGuNHIrtDuI5F,-LIcTY2OGuNHIrtDuI5G"]
/*
let packsTechniques = ["bodyScan", "bodyScan", "bodyScan", "bodyScan,noting", "bodyScan,noting", "bodyScan,visualization", "bodyscan,restingAwareness,visualization", "bodyScan,visualization,skillfulCompassion", "bodyScan,noting,visualization", "bodyScan,focusedAttention,restingAwareness", "bodyScan,noting,visualization", "bodyScan,focusedAttention,visualization,lovingKindness", "bodyScan,noting", "focusedAttention,bodyScan", "bodyScan,noting", "noting,bodyScan", "noting,visualization,restingAwareness", "bodyScan,visualization,-LIcTY2PUO2s4R3FEqfI", "bodyScan,noting", "bodyScan,visualization", "bodyScan,reflection", "bodyScan,reflection", "bodyScan,visualization,skillfulCompassion", "bodyScan,visualization,noting", "bodyScan,focusedAttention", "bodyScan,noting", "bodyScan,visualization", "bodyScan,visualization", "bodyScan,visualization", "bodyScan,focusedAttention", "bodyScan,focusedAttention", "bodyscan,restingAwareness", "bodyscan,restingAwareness", "bodyscan,restingAwareness", "bodyscan,restingAwareness", "bodyscan,restingAwareness", "bodyscan,restingAwareness", "bodyScan,reflection", "bodyScan,focusedAttention", "bodyScan,noting", "bodyScan,focusedAttention", "bodyScan", "bodyScan,focusedAttention", "bodyScan,visualization", "bodyScan,visualization"]*/
let packsDetails = ["Train your mind for a happier, healthier life by learning the fundamentals of meditation and mindfulness.", "Discover more about your mind and start to deepen your practice.", "Overcome some of the more common obstacles in meditation and learn how to apply mindfulness to your everyday life.", "Become more aware of your relationship to food and the thoughts that drive your choices.", "Become more aware of your anxiety and start to experience it from a different perspective.", "Enjoy a healthier mind by developing your awareness of stress and learning how to reframe negative emotions.", "Create the inner and outer conditions you need for a truly restful night’s sleep. Designed for use along with our Sleeping single.", "Develop more favorable conditions for conception, pregnancy and birth. Designed for both moms and dads to-be.", "Find a greater sense of understanding and perspective as you go through one of your most challenging journeys. Preliminary research using in-person meditation training techniques suggests that meditation may help improve quality of life for people with cancer. There is no evidence to suggest that meditation can help to prevent, treat, or cure cancer. It is usually safe to use meditation alongside your cancer treatment, but it is important to talk to your doctor if you have any concerns.", "Change your relationship with pain by observing it from a new perspective.", "Sadness doesn't have to weigh us down. Start seeing your thoughts with a new perspective so you can learn to let them go.", "There's no right or wrong way to grieve. Create room to heal while allowing a sense of healthy connection to live on.", "Regret is a difficult feeling. Lessen its sting by learning to let go of the past.", "Anger is a natural part of life. Learn to connect with it and use it to train your mind.", "Train your mind to experience a greater sense of flow and be more comfortable with change.", "Start to understand your restlessness and learn to work with it more skillfully.", "Move towards a less judgmental inner life by creating some space in your mind to observe negative and self-critical thinking.", "Learn to focus less on self-critical chatter to achieve greater harmony with others and within yourself.", "Learn to recognize impatience, process it and let it go.", "Develop a more playful attitude towards life and begin to understand how your own happiness impacts others.", "Learn to let go of resistance and find acceptance not just toward your own thoughts and feelings, but also other people and difficult situations.", "Discover a renewed sense of appreciation both for yourself and the world around you.", "Foster feelings of compassion towards yourself and learn to judge others less harshly too.", "Cultivate an attitude of general openness by training your mind to be less judgmental and critical. You’ll feel the benefits and so will others.", "When there’s a lot competing for your attention, get some clarity on what really matters to you.", "Practice maintaining focus to make your days more productive and efficient.", "Familiarize yourself with a relaxed, precise kind of focus. Neither too intense, nor too loose.", "Learn how to recognize your creativity and give it the freedom to grow.", "Work towards a more balanced mind, recognize calmness and become less reactive, even in tough situations.", "Starting a new chapter in life can be challenging. Learn to cope with the change by creating a sense of stability in the mind.", "Create a calm environment for your studies as you learn to recognize distractions and let them go.", "Get comfortable with silence. Your mind will behave more independently and your meditation becomes more personal.", "Meditating in silence can be tough. Start to see difficulties as opportunities to refine your technique.", "In silence, the mind can become overactive or sluggish. Learn how to gently moderate these extremes to experience a clear, bright and stable mind.", "Develop your awareness and find a place of calm, quiet confidence.", "Learn to perceive thoughts, emotions and sensations in a new way so you can get less caught up in your thinking.", "Focus on your sense of me, myself and I. Learn how to step back from your identity and just experience life.", "Discover a healthy sense of perspective as you set clear intentions to pursue your goals.", "Learn to let go of the past as well as any expectation of the future.", "Make the most of every moment by learning how to set clear intentions for training sessions.", "Train your mind to let go of the inner chatter, focus and discover a place of quiet confidence.", "Build and nurture supportive relationships as you learn to give and receive constructive feedback.", "Review your performance with a healthy perspective and objective mindset.", "Learn how to relax, unwind and recover after every performance.", "Manage emotions and expectations while you devote your time and energy to a healthy recovery."]
let packsAudio = ["", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""]
let packsIsPremium = [0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]

func uploadKids(){
    //Kids Data Array
    var kidsDataArray = [Dictionary<String, Any>]()
    
    //Create Kids Data
    let ref = Database.database().reference()
    for i in stride(from: 0, to: kidsNames.count, by: 1) {
        var kidsData = Dictionary<String, Any>()
        kidsData["objectId"] = ref.childByAutoId().key
        kidsData["createdAt"] = ServerValue.timestamp()
        kidsData["updatedAt"] = ServerValue.timestamp()
        kidsData["name"] = kidsNames[i]
        //kidsData["image"] = kidsImages[i]
        kidsData["coverImage"] = kidsCoverImages[i]
        kidsData["category"] = kidsCategories[i]
        kidsData["subCategories"] = kidsSubCategories[i]
        kidsData["sessionLengths"] = kidsSessionLengths[i]
        kidsData["details"] = kidsDetails[i]
        kidsData["audio"] = kidsAudio[i]
        kidsData["isPremium"] = kidsIsPremium[i]
        kidsDataArray.append(kidsData)
    }
    
    for i in stride(from: 0, to: imageNames.count, by: 1) {
        //Convert Image to Data
        let imageData = UIImageJPEGRepresentation(UIImage(named: imageNames[i])!, 0.7)
        //Save Item Image
        let imageFileName = String(format: "%@Image.jpeg", imageNames[i])
        let storageRef = Storage.storage().reference()
        _ = storageRef.child(singlesDatabase).child(imageNames[i]).child(imageFileName).putData(imageData!, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
            }
            // Metadata contains file metadata such as size, content-type, and download URL.
            let downloadURL: URL = metadata.downloadURL()!
            print(downloadURL.absoluteString)
            
            //Upload Kids to Database
            var kidsData = kidsDataArray[i]
            kidsData["image"] = downloadURL.absoluteString
            ref.child(singlesDatabase).child(kidsData["objectId"] as! String).setValue(kidsData) { (error:Error?, DatabaseReference) in
                if((error) != nil){
                    print("Error uploading kid")
                }
            }
        }
    }
}


//Kids Raw Data
let kidsNames = ["Appreciation", "Balance", "Happiness", "Sleep", "Calm", "Kindness", "Paying Attention", "Wake Up"]
let kidsImages = ["Appreciation", "Balance", "Happiness", "Sleep", "Calm", "Kindness", "Paying Attention", "Wake Up"]
let kidsCoverImages = ["https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSSingles%2Fappreciation%2FappreciationCoverImage.jpeg?alt=media&token=44cdf16b-7960-484c-8378-f5b404d66c07", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSSingles%2Fbalance%2FbalanceCoverImage.jpeg?alt=media&token=f9474754-ab73-4571-9a19-2a509cb147da", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSSingles%2Fhappiness%2FhappinessCoverImage.jpeg?alt=media&token=a590e664-de76-4110-9ebb-44f1b2babdf6", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSSingles%2Fsleep%2FsleepCoverImage.jpeg?alt=media&token=75f319ae-fc28-4f09-b9fd-af2f3e4f247c", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSSingles%2Fcalm%2FcalmCoverImage.jpeg?alt=media&token=3bd55731-c3d6-4398-946d-a1ee866c1d9c", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSSingles%2Fkindness%2FkindnessCoverImage.jpeg?alt=media&token=e8b65044-33d8-4401-8661-20ba71eaaa2c", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSSingles%2FpayingAttention%2FpayingAttentionCoverImage.jpeg?alt=media&token=e053ab07-8cf9-439e-b255-def0cc0bfe8d", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSSingles%2FwakeUp%2FwakeUpCoverImage.jpeg?alt=media&token=2a8e3e8f-e367-4f61-8d5a-3a9f0c18cb06"]
let kidsCategories = ["Kids", "Kids", "Kids", "Kids", "Kids", "Kids", "Kids", "Kids"]
let kidsSubCategories = ["ages5AndUnder,ages6To8,ages9To12", "ages5AndUnder,ages6To8,ages9To12", "ages5AndUnder,ages6To8,ages9To12", "ages5AndUnder,ages6To8,ages9To12", "ages5AndUnder,ages6To8,ages9To12", "ages5AndUnder,ages6To8,ages9To12", "ages5AndUnder,ages6To8,ages9To12", "ages5AndUnder,ages6To8,ages9To12"]
let kidsSessionLengths = ["", "", "", "", "", "", "", ""]
let kidsDetails = ["A visualization to help kids get in touch with a feeling of gratitude for the world around them and the people in it.", "In this exercise, kids learn how to recognize calmness and be less reactive.", "Kids will learn to focus on a light, playful attitude towards life with this exercise.", "A relaxing mindfulness activity that helps kids get a good night’s rest.", "Learn the fundamentals of meditation with this simple, fun breathing exercise.", "A visualization exercise that teaches children about openness and generosity.", "Kids will use their imagination to practice a relaxed, precise kind of focus.", "This quick meditation helps little ones start the day off right."]
let kidsAudio = ["", "", "", "", "", "", "", ""]
let kidsIsPremium = [1, 1, 1, 1, 1, 1, 1, 1]
/*
func uploadAnimations(){
    //Animations Data Array
    var animationsDataArray = [Dictionary<String, Any>]()
    
    //Create Animations Data
    let ref = Database.database().reference()
    for i in stride(from: 0, to: animationsNames.count, by: 1) {
        var animationsData = Dictionary<String, Any>()
        animationsData["objectId"] = ref.childByAutoId().key
        animationsData["createdAt"] = ServerValue.timestamp()
        animationsData["updatedAt"] = ServerValue.timestamp()
        animationsData["name"] = animationsNames[i]
        //animationsData["image"] = animationsImages[i]
        animationsData["coverImage"] = animationsCoverImages[i]
        animationsData["category"] = animationsCategories[i]
        animationsData["details"] = animationsDetails[i]
        animationsData["video"] = animationsVideo[i]
        animationsData["isPremium"] = animationsIsPremium[i]
        animationsDataArray.append(animationsData)
    }
    
    for i in stride(from: 0, to: imageNames.count, by: 1) {
        //Convert Image to Data
        let imageData = UIImageJPEGRepresentation(UIImage(named: imageNames[i])!, 0.7)
        //Save Item Image
        let imageFileName = String(format: "%@Image.jpeg", imageNames[i])
        let storageRef = Storage.storage().reference()
        _ = storageRef.child(animationsDatabase).child(imageNames[i]).child(imageFileName).putData(imageData!, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
            }
            // Metadata contains file metadata such as size, content-type, and download URL.
            let downloadURL: URL = metadata.downloadURL()!
            print(downloadURL.absoluteString)
            
            //Upload Animations to Database
            var animationsData = animationsDataArray[i]
            animationsData["image"] = downloadURL.absoluteString
            ref.child(animationsDatabase).child(animationsData["objectId"] as! String).setValue(animationsData) { (error:Error?, DatabaseReference) in
                if((error) != nil){
                    print("Error uploading animation")
                }
            }
        }
    }
}*/

func uploadAnimations(){
    //Animations Data Array
    var animationsDataArray = [Dictionary<String, Any>]()
    
    //Create Animations Data
    let ref = Database.database().reference()
    for i in stride(from: 0, to: animationsNames.count, by: 1) {
        var animationsData = Dictionary<String, Any>()
        animationsData["objectId"] = ref.childByAutoId().key
        animationsData["createdAt"] = ServerValue.timestamp()
        animationsData["updatedAt"] = ServerValue.timestamp()
        animationsData["name"] = animationsNames[i]
        animationsData["image"] = animationsImages[i]
        animationsData["coverImage"] = animationsCoverImages[i]
        animationsData["category"] = animationsCategories[i]
        animationsData["details"] = animationsDetails[i]
        animationsData["video"] = animationsVideo[i]
        animationsData["isPremium"] = animationsIsPremium[i]
        animationsDataArray.append(animationsData)
    }
    
    //Upload Animations to Database
    for animationsData in animationsDataArray{
        ref.child(animationsDatabase).child(animationsData["objectId"] as! String).setValue(animationsData) { (error:Error?, DatabaseReference) in
            if((error) != nil){
                print("Error uploading animation")
            }
        }
    }
}

//Animations Raw Data
let animationsNames = ["Getting started", "Changing perspective", "Letting go of effort", "Underlying calm", "Accepting the mind", "Am I doing it right?", "Am I making progress?", "Get back on the wagon", "Free your mind", "Mind, body, speech", "Thinking about thinking", "Learning a skill", "Hole in the road", "Monkey mind", "Beginner's mind", "Elephant slow and steady", "Impatient yogi", "Dark side of the mind", "Can't control the waves", "Polishing a Pan", "Letting go", "Planting a seed", "Happiness of others", "Impermanence and change", "Precious human life", "Shared human condition", "Cause and effect", "Quiet confidence", "Big mind, small mind", "Pointing at the moon", "Where are thoughts?", "Waves and the ocean", "Emptiness", "Limitless mind", "Illusion of self", "Compassion and awareness", "Body scan", "Visualization", "Noting", "Loving kindness", "Reflection", "Skillful Compassion", "Resting awareness", "Focused Attention"]
let animationsImages = ["", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSAnimations%2FbodyScan%2FbodyScanImage.jpeg?alt=media&token=dfc2e781-443a-4a6f-8789-1453aecce44e", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSAnimations%2Fvisualization%2FvisualizationImage.jpeg?alt=media&token=9f4eb68b-abb5-40bb-bdf0-7cc64937e292", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSAnimations%2Fnoting%2FnotingImage.jpeg?alt=media&token=591ab2c5-1723-43fd-911c-63891e8e3077", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSAnimations%2FlovingKindness%2FlovingKindnessImage.jpeg?alt=media&token=288c8df0-cc7a-4b07-b7dd-1039256696e0", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSAnimations%2Freflection%2FreflectionImage.jpeg?alt=media&token=b29cf5b2-a0c4-4591-af01-1e782259884c", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSAnimations%2FskillfulCompassion%2FskillfulCompassionImage.jpeg?alt=media&token=59376d70-fdd2-4bf6-8d23-f277d9646dc0", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSAnimations%2FrestingAwareness%2FrestingAwarenessImage.jpeg?alt=media&token=3746c26e-40c2-481f-a8ee-9724fce42344", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSAnimations%2FfocusedAttention%2FfocusedAttentionImage.jpeg?alt=media&token=9b474ca9-185d-43ad-9b52-efd67897f051"]
let animationsCoverImages = ["https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSAnimations%2FgettingStarted%2FgettingStartedCoverImage.jpeg?alt=media&token=f10a99f5-edd5-455a-977e-415a88c3eda1", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSAnimations%2FchangingPerspective%2FchangingPerspectiveCoverImage.jpeg?alt=media&token=4ccf7e80-baa5-491c-ad0e-087ca5b3643e", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSAnimations%2FlettingGoOfEffort%2FlettingGoOfEffortCoverImage.jpeg?alt=media&token=7dbed5f9-bb7c-4070-b9ac-dc47e5f66cd8", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSAnimations%2FunderlyingCalm%2FunderlyingCalmCoverImage.jpeg?alt=media&token=dd956a52-66a3-48f9-9bb1-99526048c025", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSAnimations%2FacceptingTheMind%2FacceptingTheMindCoverImage.jpeg?alt=media&token=a91ce49f-fa39-4c41-a82e-7f7a065322ca", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSAnimations%2FamIDoingItRight%2FamIDoingItRightCoverImage.jpeg?alt=media&token=d7650388-95e8-417d-990a-fc10d309f959", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSAnimations%2FamIMakingProgress%2FamIMakingProgressCoverImage.jpeg?alt=media&token=1828eee8-835a-412b-b847-e9284c79ff5e", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSAnimations%2FgetBackOnTheWagon%2FgetBackOnTheWagonCoverImage.jpeg?alt=media&token=f99decb7-0997-49e9-aee7-ccbb5ee4de29", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSAnimations%2FfreeYourMind%2FfreeYourMindCoverImage.jpeg?alt=media&token=5783383e-5ca4-4efe-ac8b-87e871042207", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSAnimations%2FmindBodySpeech%2FmindBodySpeechCoverImage.jpeg?alt=media&token=510a824b-6f7c-4139-b842-88ad20fcbed6", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSAnimations%2FthinkingAboutThinking%2FthinkingAboutThinkingCoverImage.jpeg?alt=media&token=4f93126f-6a87-42bf-bb02-46009ff2d7a5", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSAnimations%2FlearningASkill%2FlearningASkillCoverImage.jpeg?alt=media&token=0c566ebb-8921-494d-ad17-4acc51c8f1dd", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSAnimations%2FholeInTheRoad%2FholeInTheRoadCoverImage.jpeg?alt=media&token=0d797a3c-0a4b-42bb-a323-d71b3b618d6d", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSAnimations%2FmonkeyMind%2FmonkeyMindCoverImage.jpeg?alt=media&token=99c4fd38-d83d-4c5e-9c57-4d2d36135260", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSAnimations%2FbeginnersMind%2FbeginnersMindCoverImage.jpeg?alt=media&token=2f1cfffe-8e24-49dc-94ff-d85ea5628cd8", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSAnimations%2FelephantSlowAndSteady%2FelephantSlowAndSteadyCoverImage.jpeg?alt=media&token=c976e15a-d49e-4a9e-a3cf-5fe3b8c79afc", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSAnimations%2FimpatientYogi%2FimpatientYogiCoverImage.jpeg?alt=media&token=dfceea83-61c9-4679-b5c7-d48dd4eb97b2", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSAnimations%2FdarkSideOfTheMind%2FdarkSideOfTheMindCoverImage.jpeg?alt=media&token=7b6e5420-28ac-4edd-b623-79899bf256df", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSAnimations%2FcantControlTheWaves%2FcantControlTheWavesCoverImage.jpeg?alt=media&token=b2fc8ca0-145c-4084-9294-a10a33dcc62e", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSAnimations%2FpolishingAPan%2FpolishingAPanCoverImage.jpeg?alt=media&token=57c8faad-4cf4-44a2-8cfd-3d19685111f3", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSAnimations%2FlettingGo%2FlettingGoCoverImage.jpeg?alt=media&token=8c242ff1-a7c4-4bc1-92e1-e472f6366253", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSAnimations%2FplantingASeed%2FplantingASeedCoverImage.jpeg?alt=media&token=ceb28dc4-5e54-461c-b3c3-b517e1d639bf", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSAnimations%2FhappinessOfOthers%2FhappinessOfOthersCoverImage.jpeg?alt=media&token=425b0bf2-8d58-4db8-94ae-304602fafa91", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSAnimations%2FimpermanenceAndChange%2FimpermanenceAndChangeCoverImage.jpeg?alt=media&token=3937a79a-35ff-4c4c-9669-c888978d6181", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSAnimations%2FpreciousHumanLife%2FpreciousHumanLifeCoverImage.jpeg?alt=media&token=1f52c1ae-9e54-40a6-8863-008e774dfe0d", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSAnimations%2FsharedHumanCondition%2FsharedHumanConditionCoverImage.jpeg?alt=media&token=8f534f23-70f7-499d-8c23-31eef16616e5", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSAnimations%2FcauseAndEffect%2FcauseAndEffectCoverImage.jpeg?alt=media&token=f9dd46cd-c311-4bd9-8f93-bd8ccb229b22", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSAnimations%2FquietConfidence%2FquietConfidenceCoverImage.jpeg?alt=media&token=20f19d83-ac0b-48fc-a8a6-206e34938f88", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSAnimations%2FbigMindSmallMind%2FbigMindSmallMindCoverImage.jpeg?alt=media&token=b8124258-9420-404c-b022-5304734c68f2", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSAnimations%2FpointingAtTheMoon%2FpointingAtTheMoonCoverImage.jpeg?alt=media&token=81de8638-6f37-434d-87aa-92f42869cf54", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSAnimations%2FwhereAreThoughts%2FwhereAreThoughtsCoverImage.jpeg?alt=media&token=93350749-cc49-4e1f-a607-582870490e18", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSAnimations%2FwavesAndTheOcean%2FwavesAndTheOceanCoverImage.jpeg?alt=media&token=68101e90-a2b4-43a6-8a9f-4f4ca6d675e6", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSAnimations%2Femptiness%2FemptinessCoverImage.jpeg?alt=media&token=75a9e950-29c6-41a6-8753-a55ad5a1a1a2", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSAnimations%2FlimitlessMind%2FlimitlessMindCoverImage.jpeg?alt=media&token=43e16978-6583-4918-a05f-686797cc87aa", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSAnimations%2FillusionOfSelf%2FillusionOfSelfCoverImage.jpeg?alt=media&token=0f3f62e6-bf03-408d-9eac-68f083ec7a8f", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSAnimations%2FcompassionAndAwareness%2FcompassionAndAwarenessCoverImage.jpeg?alt=media&token=5ce9ad3c-fbcc-4d02-837d-f953a9532939", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSAnimations%2FbodyScan%2FbodyScanCoverImage.jpeg?alt=media&token=f94d64fa-5dca-4947-a2e2-753fd0279de1", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSAnimations%2Fvisualization%2FvisualizationCoverImage.jpeg?alt=media&token=a543d66e-59cc-4428-bd09-2b1da0044306", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSAnimations%2Fnoting%2FnotingCoverImage.jpeg?alt=media&token=302087f0-6f69-4022-8316-e1e33275bc8f", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSAnimations%2FlovingKindness%2FlovingKindnessCoverImage.jpeg?alt=media&token=b0a667a5-24c2-4801-96ec-a77b0643b438", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSAnimations%2Freflection%2FreflectionCoverImage.jpeg?alt=media&token=14724786-fb38-41d9-9e33-0953e9a3c48d", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSAnimations%2FskillfulCompassion%2FskillfulCompassionCoverImage.jpeg?alt=media&token=c472669e-4167-42a2-9182-9d53b2c1a248", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSAnimations%2FrestingAwareness%2FrestingAwarenessCoverImage.jpeg?alt=media&token=e03c75c7-c85c-4969-8bb4-b2da4a0bd144", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSAnimations%2FfocusedAttention%2FfocusedAttentionCoverImage.jpeg?alt=media&token=ad4daf1d-7cbe-4af7-aa29-c33712165cb2"]
let animationsCategories = ["Getting Started", "Getting Started", "Getting Started", "Getting Started", "Getting Started", "Doubts & Difficulties", "Doubts & Difficulties", "Doubts & Difficulties", "Doubts & Difficulties", "Doubts & Difficulties", "Doubts & Difficulties", "Maintaining Meditation", "Maintaining Meditation", "Maintaining Meditation", "Maintaining Meditation", "Maintaining Meditation", "Maintaining Meditation", "Maintaining Meditation", "Maintaining Meditation", "Maintaining Meditation", "Maintaining Meditation", "Right Attitude", "Right Attitude", "Right Attitude", "Right Attitude", "Right Attitude", "Right Attitude", "Right Attitude", "Understanding the Mind", "Understanding the Mind", "Understanding the Mind", "Understanding the Mind", "Understanding the Mind", "Understanding the Mind", "Understanding the Mind", "Understanding the Mind", "Techniques", "Techniques", "Techniques", "Techniques", "Techniques", "Techniques", "Techniques", "Techniques"]
let animationsDetails = ["How to begin with a brilliant attitude", "How to begin with a brilliant attitude", "How to begin with a brilliant attitude", "How to begin with a brilliant attitude", "How to begin with a brilliant attitude", "Common obstacles taken care of", "Common obstacles taken care of", "Common obstacles taken care of", "Common obstacles taken care of", "Common obstacles taken care of", "Common obstacles taken care of", "Develop your practice and stick with it", "Develop your practice and stick with it", "Develop your practice and stick with it", "Develop your practice and stick with it", "Develop your practice and stick with it", "Develop your practice and stick with it", "Develop your practice and stick with it", "Develop your practice and stick with it", "Develop your practice and stick with it", "Develop your practice and stick with it", "Great ideas for maintaining motivation", "Great ideas for maintaining motivation", "Great ideas for maintaining motivation", "Great ideas for maintaining motivation", "Great ideas for maintaining motivation", "Great ideas for maintaining motivation", "Great ideas for maintaining motivation", "Big ideas for experienced meditators", "Big ideas for experienced meditators", "Big ideas for experienced meditators", "Big ideas for experienced meditators", "Big ideas for experienced meditators", "Big ideas for experienced meditators", "Big ideas for experienced meditators", "Big ideas for experienced meditators", "Eight key techniques used in our packs", "Eight key techniques used in our packs", "Eight key techniques used in our packs", "Eight key techniques used in our packs", "Eight key techniques used in our packs", "Eight key techniques used in our packs", "Eight key techniques used in our packs", "Eight key techniques used in our packs"]
let animationsVideo = ["https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSAnimations%2FgettingStarted%2FgettingStartedVideo.mp4?alt=media&token=c1f3a9bd-ab5d-4cc7-8af0-1fbfe6eccc99", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSAnimations%2FchangingPerspective%2FchangingPerspectiveVideo.mp4?alt=media&token=1519e6a1-02ae-4213-a806-451baec624e9", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSAnimations%2FlettingGoOfEffort%2FlettingGoOfEffortVideo.mp4?alt=media&token=0bfbef8b-1c3c-408d-8fe6-a7c0c3cb0aa1", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSAnimations%2FunderlyingCalm%2FunderlyingCalmVideo.mp4?alt=media&token=19fe915f-19ec-460c-8003-1ff694d37342", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSAnimations%2FacceptingTheMind%2FacceptingTheMindVideo.mp4?alt=media&token=f0131950-d028-43b9-bf0f-1a66775e2ca2", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSAnimations%2FamIDoingItRight%2FamIDoingItRightVideo.mp4?alt=media&token=c0b15215-df5a-4610-93a5-1d3a4d1862a2", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSAnimations%2FamIMakingProgress%2FamIMakingProgressVideo.mp4?alt=media&token=db0e2471-2fb4-4796-af21-5912bf856b24", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSAnimations%2FgetBackOnTheWagon%2FgetBackOnTheWagonVideo.mp4?alt=media&token=99902466-e20e-481b-8f92-f4fab7515388", "", "", "", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSAnimations%2FlearningASkill%2FlearningASkillVideo.mp4?alt=media&token=8c56d598-037f-4b42-b541-342be6b31fe1", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSAnimations%2FholeInTheRoad%2FholeInTheRoadVideo.mp4?alt=media&token=ac52011b-3ee0-4147-be25-663e9b381ab7", "", "", "", "", "", "", "", "", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSAnimations%2FplantingASeed%2FplantingASeedVideo.mp4?alt=media&token=ecdb42f8-3c73-4aa3-abfe-b64c5ac37850", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSAnimations%2FbodyScan%2FbodyScanVideo.mp4?alt=media&token=3aefdd43-9bd9-4fcf-8156-9dac2bf0ad93", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSAnimations%2Fvisualization%2FvisualizationVideo.mp4?alt=media&token=8365591b-eb1b-4ae1-804c-adccbb3843b6", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSAnimations%2Fnoting%2FnotingVideo.mp4?alt=media&token=24e2c790-fa00-4a61-94fb-8bfbf65d589a", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSAnimations%2FlovingKindness%2FlovingKindnessVideo.mp4?alt=media&token=762be0bf-4a5c-45e9-985a-ab9132a86286", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSAnimations%2Freflection%2FreflectionVideo.mp4?alt=media&token=5dc9846a-b9e0-4a45-89af-0a06ecae3ae7", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSAnimations%2FskillfulCompassion%2FskillfulCompassionVideo.mp4?alt=media&token=92c2a0d7-acb1-4ee1-9258-11a5908e7ccd", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSAnimations%2FrestingAwareness%2FrestingAwarenessVideo.mp4?alt=media&token=31935a68-fd30-46c3-85d6-1551ce90bcad", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSAnimations%2FfocusedAttention%2FfocusedAttentionVideo.mp4?alt=media&token=9f88095d-d911-43af-9f3c-f359514fc252"]
let animationsIsPremium = [0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0]

func uploadMinis(){
    //Minis Data Array
    var minisDataArray = [Dictionary<String, Any>]()
    
    //Create Packs Data
    let ref = Database.database().reference()
    for i in stride(from: 0, to: minisNames.count, by: 1) {
        var minisData = Dictionary<String, Any>()
        minisData["objectId"] = ref.childByAutoId().key
        minisData["createdAt"] = ServerValue.timestamp()
        minisData["updatedAt"] = ServerValue.timestamp()
        minisData["name"] = minisNames[i]
        minisData["image"] = minisImages[i]
        minisData["coverImage"] = minisCoverImages[i]
        minisData["sessions"] = minisSessions[i]
        minisData["sessionLengths"] = minisSessionLengths[i]
        minisData["details"] = minisDetails[i]
        minisData["audio"] = minisAudio[i]
        minisData["isPremium"] = minisIsPremium[i]
        minisDataArray.append(minisData)
    }
    
    //Upload Minis to Database
    for minisData in minisDataArray{
        ref.child(minisDatabase).child(minisData["objectId"] as! String).setValue(minisData) { (error:Error?, DatabaseReference) in
            if((error) != nil){
                print("Error uploading mini")
            }
        }
    }
}

//minis Raw Data
let minisNames = ["Breathe", "Unwind", "Restore", "Body Scan", "Focus", "Refresh"]
let minisImages = ["https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSMinis%2Fbreathe%2FbreatheImage.jpeg?alt=media&token=26975437-101b-4710-b740-75cfa1554f06", "", "", "", "", ""]
let minisCoverImages = ["https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSMinis%2Fbreathe%2FbreatheCoverImage.jpeg?alt=media&token=92223f4c-a8e4-451e-ae00-9cb310e1295c", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSMinis%2Funwind%2FunwindCoverImage.jpeg?alt=media&token=1692ecf9-1318-4e66-b267-5ac20684de22", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSMinis%2Frestore%2FrestoreCoverImage.jpeg?alt=media&token=831325eb-2d60-4cd7-977a-c37a32a10eac", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSMinis%2FbodyScan%2FbodyScanCoverImage.jpeg?alt=media&token=e8b87607-3297-4205-adcb-e7d2f6845e77", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSMinis%2Ffocus%2FfocusCoverImage.jpeg?alt=media&token=f0780f85-aaa8-49a1-85b6-b24ef594ed26", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSMinis%2Frefresh%2FrefreshCoverImage.jpeg?alt=media&token=422f85d5-ecca-4861-b06f-c20f031b47ee"]
let minisSessions = [1, 1, 1, 1, 1, 1]
let minisSessionLengths = ["1", "1", "1", "1", "1", "1"]
let minisDetails = ["Bring a sense of spaciousness into your day with a quick beathing exercise.", "Bring your mind to a natural place of rest with a simple mindfulness exercise.", "Let go of any tension or business in the mind with a brief meditation.", "Bring mind and body together with this classic meditation technique.", "Bring ou the innate focus within you through a quick mindfulness exercise.", "Wash away any tension in the body with a classic visualization technique."]
let minisAudio = ["", "", "", "", "", "", "", ""]
let minisIsPremium = [0, 1, 1, 1, 1, 1]


func uploadSingles(){
    //Singles Data Array
    var singlesDataArray = [Dictionary<String, Any>]()
    
    //Create Singles Data
    let ref = Database.database().reference()
    for i in stride(from: 0, to: singlesNames.count, by: 1) {
        var singlesData = Dictionary<String, Any>()
        singlesData["objectId"] = ref.childByAutoId().key
        singlesData["createdAt"] = ServerValue.timestamp()
        singlesData["updatedAt"] = ServerValue.timestamp()
        singlesData["name"] = singlesNames[i]
        //singlesData["image"] = singlesImages[i]
        singlesData["coverImage"] = singlesCoverImages[i]
        singlesData["category"] = singlesCategories[i]
        singlesData["sessionLengths"] = singlesSessionLengths[i]
        singlesData["introductionLengths"] = singlesIntroductionLengths[i]
        singlesData["details"] = singlesDetails[i]
        singlesData["audio"] = singlesAudio[i]
        singlesData["introductionAudio"] = singlesIntroductionAudio[i]
        singlesData["isPremium"] = singlesIsPremium[i]
        singlesDataArray.append(singlesData)
    }
    
    for i in stride(from: 0, to: imageNames.count, by: 1) {
        //Convert Image to Data
        let imageData = UIImageJPEGRepresentation(UIImage(named: imageNames[i])!, 0.7)
        //Save Item Image
        let imageFileName = String(format: "%@Image.jpeg", imageNames[i])
        let storageRef = Storage.storage().reference()
        _ = storageRef.child(singlesDatabase).child(imageNames[i]).child(imageFileName).putData(imageData!, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
            }
            // Metadata contains file metadata such as size, content-type, and download URL.
            let downloadURL: URL = metadata.downloadURL()!
            print(downloadURL.absoluteString)
            
            //Upload Singles to Database
            var singlesData = singlesDataArray[i]
            singlesData["image"] = downloadURL.absoluteString
            ref.child(singlesDatabase).child(singlesData["objectId"] as! String).setValue(singlesData) { (error:Error?, DatabaseReference) in
                if((error) != nil){
                    print("Error uploading single")
                }
            }
        }
    }
}
/*
func uploadSingles(){
    //Singles Data Array
    var singlesDataArray = [Dictionary<String, Any>]()
    
    //Create Singles Data
    let ref = Database.database().reference()
    for i in stride(from: 0, to: singlesNames.count, by: 1) {
        var singlesData = Dictionary<String, Any>()
        singlesData["objectId"] = ref.childByAutoId().key
        singlesData["createdAt"] = ServerValue.timestamp()
        singlesData["updatedAt"] = ServerValue.timestamp()
        singlesData["name"] = singlesNames[i]
        singlesData["image"] = singlesImages[i]
        singlesData["coverImage"] = singlesCoverImages[i]
        singlesData["category"] = singlesCategories[i]
        singlesData["sessionLengths"] = singlesSessionLengths[i]
        singlesData["introductionLengths"] = singlesIntroductionLengths[i]
        singlesData["details"] = singlesDetails[i]
        singlesData["audio"] = singlesAudio[i]
        singlesData["introductionAudio"] = singlesIntroductionAudio[i]
        singlesData["isPremium"] = singlesIsPremium[i]
        singlesDataArray.append(singlesData)
    }
    
    //Upload Singles to Database
    for singlesData in singlesDataArray{
        ref.child(singlesDatabase).child(singlesData["objectId"] as! String).setValue(singlesData) { (error:Error?, DatabaseReference) in
            if((error) != nil){
                print("Error uploading single")
            }
        }
    }
}*/

//Singles Raw Data
let singlesNames = ["Guided", "Unguided", "First Run", "Second Run", "Keep Running", "Cycling", "In the City", "In Your Home", "Parks & Nature", "Burned Out", "Feeling Overwhelmed", "Flustered", "Losing Your Temper", "Panicking", "In Pain", "Early Mornings", "Waking Up", "Sleeping", "Falling Back to Sleep", "Sound: doze", "Sound: snooze", "Sound: dream", "Sound: slumber", "Sound: drift off", "Sound: power down", "Alone Time", "Reset", "End of Day", "For the Weekend", "Stressed", "Frustrated", "Under the Weather", "Creative Writing", "Gardening", "Housework", "Mindful Tech", "Presentations", "Taking a Break", "Interviews", "Fear of Flying", "Difficult Conversations", "Exams", "Commuting", "Vacation", "Cooking", "Eating", "Competition", "Concentration", "Motivation", "Training", "Rehab", "Recovery", "Analysis", "Communication"]
let singlesImages = ["", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""]
let singlesCoverImages = ["https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSSingles%2Fguided%2FguidedCoverImage.jpeg?alt=media&token=e093b646-49f8-4f4e-a855-eecd390b6591", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSSingles%2Funguided%2FunguidedCoverImage.jpeg?alt=media&token=dfd6ca07-c9ca-4383-a282-9b30773b407a", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSSingles%2FfirstRun%2FfirstRunCoverImage.jpeg?alt=media&token=4eb7a4ca-28e7-4b6a-ad80-fb13cc5d667c", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSSingles%2FsecondRun%2FsecondRunCoverImage.jpeg?alt=media&token=56c73fa7-2186-42ea-b019-f557f5db5544", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSSingles%2FkeepRunning%2FkeepRunningCoverImage.jpeg?alt=media&token=1aaaab83-b295-4d3b-bf9a-e57e65fe7c7f", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSSingles%2Fcycling%2FcyclingCoverImage.jpeg?alt=media&token=c8910202-cdd2-4dcf-81ed-5bc1ce30a2bc", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSSingles%2FinTheCity%2FinTheCityCoverImage.jpeg?alt=media&token=3c1ddb81-67dc-4fe6-a3c1-ec64b3483fd3", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSSingles%2FinYourHome%2FinYourHomeCoverImage.jpeg?alt=media&token=c30d1cb1-1d59-44f8-8aa0-a08d49c4ac26", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSSingles%2FparksAndNature%2FparksAndNatureCoverImage.jpeg?alt=media&token=0172ee93-3b4c-413b-8900-1ff5da40180f", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSSingles%2FburnedOut%2FburnedOutCoverImage.jpeg?alt=media&token=cd131c71-ae1b-416d-aa67-5aefc2b97ddc", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSSingles%2FfeelingOverwhelmed%2FfeelingOverwhelmedCoverImage.jpeg?alt=media&token=08f24b0f-79b6-4db4-88f3-ff36ff59a85e", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSSingles%2Fflustered%2FflusteredCoverImage.jpeg?alt=media&token=7d1134c4-ba73-4f2e-8327-51860cb89024", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSSingles%2FlosingYourTemper%2FlosingYourTemperCoverImage.jpeg?alt=media&token=adb72f09-9f6c-451e-a63f-bc86aa76dd29", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSSingles%2Fpanicking%2FpanickingCoverImage.jpeg?alt=media&token=5c8ca53e-a09d-4164-a954-f9e832f8a9c1", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSSingles%2FinPain%2FinPainCoverImage.jpeg?alt=media&token=a9d2a1f1-c32a-4c5a-8022-8a394f376527", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSSingles%2FearlyMornings%2FearlyMorningsCoverImage.jpeg?alt=media&token=a37b67d7-bfa0-4df6-a382-e0e983545dba", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSSingles%2FwakingUp%2FwakingUpCoverImage.jpeg?alt=media&token=5742ee1e-bd83-4856-82a4-3a236382a27f", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSSingles%2Fsleeping%2FsleepingCoverImage.jpeg?alt=media&token=7db6138c-841e-4fb1-9d5e-57e5539d93d8", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSSingles%2FfallingBackToSleep%2FfallingBackToSleepCoverImage.jpeg?alt=media&token=9f6d60fb-7aeb-4d29-996c-dce296df447c", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSSingles%2FsoundDoze%2FsoundDozeCoverImage.jpeg?alt=media&token=52649d6c-4bbf-4a34-af5f-d8155f48d588", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSSingles%2FsoundSnooze%2FsoundSnoozeCoverImage.jpeg?alt=media&token=5c68957f-02eb-425c-855c-ab5cde16c5d3", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSSingles%2FsoundDream%2FsoundDreamCoverImage.jpeg?alt=media&token=6bb61359-0c6c-4164-a502-b1780c606e89", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSSingles%2FsoundSlumber%2FsoundSlumberCoverImage.jpeg?alt=media&token=1c240c2e-1c36-4120-903b-51351825015f", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSSingles%2FsoundDriftOff%2FsoundDriftOffCoverImage.jpeg?alt=media&token=09c91c18-e19f-42e5-9b62-bcf2fbe0f4d8", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSSingles%2FsoundPowerDown%2FsoundPowerDownCoverImage.jpeg?alt=media&token=9e20663c-fab2-43e7-9eac-60940b0ada83", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSSingles%2FaloneTime%2FaloneTimeCoverImage.jpeg?alt=media&token=517c716a-5164-4e60-ada4-f87764045a45", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSSingles%2Freset%2FresetCoverImage.jpeg?alt=media&token=cb253737-a8c0-43fa-9cb1-04348e1fa13b", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSSingles%2FendOfDay%2FendOfDayCoverImage.jpeg?alt=media&token=93ebc3c8-f18f-42f0-ac12-3fc3425ce5ed", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSSingles%2FforTheWeekend%2FforTheWeekendCoverImage.jpeg?alt=media&token=07b77f93-cf1f-4806-8fc3-ba6241287f0d", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSSingles%2Fstressed%2FstressedCoverImage.jpeg?alt=media&token=d2c9dd7e-e286-43db-9834-85e793003444", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSSingles%2Ffrustrated%2FfrustratedCoverImage.jpeg?alt=media&token=9c888c25-81aa-4006-b017-ab08fe9b930c", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSSingles%2FunderTheWeather%2FunderTheWeatherCoverImage.jpeg?alt=media&token=d4ba20a3-0f7d-454e-950e-226426fcfdba", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSSingles%2FcreativeWriting%2FcreativeWritingCoverImage.jpeg?alt=media&token=565ee8b0-5085-48ab-91f8-42699921f4a6", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSSingles%2Fgardening%2FgardeningCoverImage.jpeg?alt=media&token=60f0ce0c-47d9-4a03-b54f-d9a2768fddf0", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSSingles%2Fhousework%2FhouseworkCoverImage.jpeg?alt=media&token=0981d972-d5cc-45c2-b608-14d6663bd840", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSSingles%2FmindfulTech%2FmindfulTechCoverImage.jpeg?alt=media&token=7cc89c83-2397-4d3f-9981-959132abd54b", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSSingles%2Fpresentations%2FpresentationsCoverImage.jpeg?alt=media&token=7532489d-c3f2-4ea8-a079-835fa13c020f", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSSingles%2FtakingABreak%2FtakingABreakCoverImage.jpeg?alt=media&token=029e0dda-4f83-4526-826b-f009ce63a1e9", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSSingles%2Finterviews%2FinterviewsCoverImage.jpeg?alt=media&token=07142022-b57e-4f08-ae91-9bb8b5c7096b", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSSingles%2FfearOfFlying%2FfearOfFlyingCoverImage.jpeg?alt=media&token=2a23b50f-9354-45b4-8168-b441d20f5116", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSSingles%2FdifficultConversations%2FdifficultConversationsCoverImage.jpeg?alt=media&token=d0a3c5de-1960-4097-9794-84e4dd94ad5e", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSSingles%2Fexams%2FexamsCoverImage.jpeg?alt=media&token=42b4c889-7a1d-4104-ac80-83b02a9499b2", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSSingles%2Fcommuting%2FcommutingCoverImage.jpeg?alt=media&token=f5c9f5ac-1e7a-4559-a475-c74ae8b91801", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSSingles%2Fvacation%2FvacationCoverImage.jpeg?alt=media&token=a6009222-78c7-401b-8b6f-4c3fe71fab89", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSSingles%2Fcooking%2FcookingCoverImage.jpeg?alt=media&token=3a2c055b-93a9-42fb-a81c-a5bb3cebee67", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSSingles%2Feating%2FeatingCoverImage.jpeg?alt=media&token=2f8f0bb1-1c94-4432-824a-da74fb4b522e", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSSingles%2Fcompetition%2FcompetitionCoverImage.jpeg?alt=media&token=a9222652-b3fb-40c9-aa9a-44c388d7ef81", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSSingles%2Fconcentration%2FconcentrationCoverImage.jpeg?alt=media&token=1921a108-a819-4234-9078-ab39e6980a6c", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSSingles%2Fmotivation%2FmotivationCoverImage.jpeg?alt=media&token=606781ba-b447-49a3-849f-18243ea743bc", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSSingles%2Ftraining%2FtrainingCoverImage.jpeg?alt=media&token=5f73e76d-70a4-4564-a659-6fb7de33d553", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSSingles%2Frehab%2FrehabCoverImage.jpeg?alt=media&token=129c04dd-65e8-4c8f-8215-4b81c874fd33", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSSingles%2Frecovery%2FrecoveryCoverImage.jpeg?alt=media&token=a783b459-c51e-4bdb-a0ba-81f29dfba56e", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSSingles%2Fanalysis%2FanalysisCoverImage.jpeg?alt=media&token=d030c152-bd39-40e2-9605-a45ceeda41c3", "https://firebasestorage.googleapis.com/v0/b/ticketmaster-23010.appspot.com/o/HSSingles%2Fcommunication%2FcommunicationCoverImage.jpeg?alt=media&token=4849ef2f-fca6-4e4b-ab33-fb3f93439bed"]
let singlesCategories = ["Classics", "Classics", "Working Out", "Working Out", "Working Out", "Working Out", "Walking", "Walking", "Walking", "SOS", "SOS", "SOS", "SOS", "SOS", "SOS", "Good Morning", "Good Morning", "Goodnight", "Goodnight", "Sleep Sounds", "Sleep Sounds", "Sleep Sounds", "Sleep Sounds", "Sleep Sounds", "Sleep Sounds", "Unwind", "Unwind", "Unwind", "Unwind", "Rough Day", "Rough Day", "Rough Day", "At Home", "At Home", "At Home", "At Work", "At Work", "At Work", "Anxious Moments", "Anxious Moments", "Anxious Moments", "Anxious Moments", "Travel", "Travel", "Food", "Food", "Sport Singles", "Sport Singles", "Sport Singles", "Sport Singles", "Sport Singles", "Sport Singles", "Sport Singles", "Sport Singles"]
let singlesSessionLengths = ["", "", "12", "15", "20", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""]
let singlesIntroductionLengths = ["1", "1", "", "", "", "1", "1", "1", "1", "", "", "", "", "", "", "1", "1", "1", "1", "", "", "", "", "", "", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "", "", "", "", "", "", "", ""]
let singlesDetails = ["Add to your practice with one-off guided meditations that can range from 10-60 minutes in length.", "Add to your practice with one-off unguided meditations that can range from 10-60 minutes in length.", "Lace up for an introductory run with Headspace’s Andy Puddicombe and Nike Running Global Head Coach Chris Bennett.", "For your second run with Andy and Nike Coach Chris Bennett, you’ll change your approach to running by becoming more aware of your thoughts.", "There’s more to running than miles and times. Use this run when you need help from Andy and Nike Coach Chris Bennett to get the most out of a workout.", "Get the most from your bike ride while increasing your awareness of hazards.", "Enjoy a walk through the city by staying present in your body and connected to the world around you.", "Practice mindfulness by noticing how your body feels as you walk.", "When we’re out in nature, we’re often caught up in our mind. Step out of that thinking and genuinely experience the world around you.", "Step away from worried thoughts and give your mind room to focus on the present.", "Give yourself a little space when you’re feeling overwhelmed.", "Bring an unsettled mind back to the subject at hand with a relaxed sense of focus.", "Take a deep breath and let go of whatever is causing you to feel angry or frustrated.", "In a fight or flight moment, anchor your mind and body in the present.", "Create a sense of ease in the body and mind by being present with your pain.", "When you have to get up before the sun does, use this visualization to recharge both mind and body.", "Let go of grogginess and begin your day feeling fresher, clearer, and brighter.", "Start to relax your body and let go of the day while easing into a restful night's sleep.", "Practice a gentle focus to bring your body back to a place of rest.", "Ease the mind into a restful night's sleep with these deep, ambient tones.", "Your body's ready for bed, but is your mind? Let light, ambient sounds help you find a place of rest.", "Create a calm environment that promotes healthy sleep with these light, mellow sounds.", "Not much compares to a good night's rest. Soothe the mind with these gentle sounds as you fall asleep.", "Ready for bed? These airy tones will help you approach your sleep with lightness and ease.", "Settle in and drift off with atmospheric tones that guide you to sleep.", "Take the opportunity to be alone for a few moments and allow yourself to unwind.", "Find a healthy balance of focus and relaxation in the middle of a rough day.", "Let go of the day and find a place of rest in both the body and the mind.", "Let go of whatever happened this week so you can fully enjoy your weekend.", "Recognize what’s occupying your mind and step away from it.", "Let go of tension and find a little peace of mind.", "Reset and recharge when you’re feeling a little off.", "Get in touch with your natural sense of creativity by allowing distractions to come and go.", "From the sun on your back to the smell of the flowers, connect with each of your senses while working in the garden.", "Enjoy being present in the moment while you tidy up your home.", "Move towards a healthier relationship with the technology around you by being a little more responsive and a little less reactive.", "Presentations can be both exciting and nerve-wracking. Anchor your mind in the present so you can truly connect with your audience.", "Press pause in the middle of your workday and reconnect with that feeling of being present.", "There’s a lot of uncertainty going into an interview. Find a place of focus and comfort in the face of any anxious feelings.", "Start to anchor yourself in physical sensations to calm the mind. Designed for use before you fly.", "Before you go into a difficult conversation, move away from a reactive mindset and towards a calmer, more responsive one.", "Exams can be intimidating, even when you’re prepared. Calm your mind and find the sweet spot between focus and relaxation.", "Be more mindful during your daily commute for a less stressful, more productive journey.", "Sometimes, we bring our worries and distractions with us on vacation. Let them go so you can make the most of your time away.", "Add a pinch of mindfulness to your cooking. You'll enjoy it more and feel less stressed.", "Develop a healthier relationship between you and your food by making your meal a little more mindful.", "Let go of the inner chatter, focus and find your place of quiet confidence.", "Find your focus by letting go of the past and your expectations for the future.", "Pursue your goals with a clear intention and a healthy sense of perspective.", "Set a clear intention to help you get the most from your training session.", "Manage your emotions and expectations while working towards a healthy recovery.", "Start to relax, unwind and recover after a performance.", "Create a healthy and objective mindset to review your performance.", "Move towards a healthy mindset that encourages supportive relationships and constructive feedback."]
let singlesAudio = ["", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""]
let singlesIntroductionAudio = ["", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""]
let singlesIsPremium = [1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]



//Upload Images

//Kids Images
//let imageNames = ["appreciation", "balance", "happiness", "sleep", "calm", "kindness", "payingAttention", "wakeUp"]
//Upload Packs Images
//let imageNames = ["basics", "basics2", "basics3", "mindfulEating", "managingAnxiety", "stress", "sleep", "pregnancy", "copingWithCancer", "painManagement", "sadness", "grief", "regret", "anger", "change", "restlessness", "selfEsteem", "relationships", "patience", "happiness", "acceptance", "appreciation", "kindness", "generosity", "prioritization", "productivity", "findingFocus", "creativity", "balance", "leavingHome", "distractions", "level1", "level2", "level3", "level4", "level5", "level6", "motivation", "concentration", "training", "competition", "communication", "analysis", "recovery", "rehab"]
//let imageNames = ["foundation", "health", "brave", "happiness", "workAndPerformance", "students", "headspacePro", "sport"]
//Upload Singles Images
//let imageNames = ["guided", "unguided", "firstRun", "secondRun", "keepRunning", "cycling", "inTheCity", "inYourHome", "parksAndNature", "burnedOut", "feelingOverwhelmed", "flustered", "losingYourTemper", "panicking", "inPain", "earlyMornings", "wakingUp", "sleeping", "fallingBackToSleep", "soundDoze", "soundSnooze", "soundDream", "soundSlumber", "soundDriftOff", "soundPowerDown", "aloneTime", "reset", "endOfDay", "forTheWeekend", "stressed", "frustrated", "underTheWeather", "creativeWriting", "gardening", "housework", "mindfulTech", "presentations", "takingABreak", "interviews", "fearOfFlying", "difficultConversations", "exams", "commuting", "vacation", "cooking", "eating", "competition", "concentration", "motivation", "training", "rehab", "recovery", "analysis", "communication"]
//Upload Minis Images
let imageNames = ["breathe", "unwind", "restore", "bodyScan", "focus", "refresh"]
//Upload Animations Images
//let imageNames = ["gettingStarted", "changingPerspective", "lettingGoOfEffort", "underlyingCalm", "acceptingTheMind", "amIDoingItRight", "amIMakingProgress", "getBackOnTheWagon", "freeYourMind", "mindBodySpeech", "thinkingAboutThinking", "learningASkill", "holeInTheRoad", "monkeyMind", "beginnersMind", "elephantSlowAndSteady", "impatientYogi", "darkSideOfTheMind", "cantControlTheWaves", "polishingAPan", "lettingGo", "plantingASeed", "happinessOfOthers", "impermanenceAndChange", "preciousHumanLife", "sharedHumanCondition", "causeAndEffect", "quietConfidence", "bigMindSmallMind", "pointingAtTheMoon", "whereAreThoughts", "wavesAndTheOcean", "emptiness", "limitlessMind", "illusionOfSelf", "compassionAndAwareness", "bodyScan", "visualization", "noting", "lovingKindness", "reflection", "skillfulCompassion", "restingAwareness", "focusedAttention"]
//let imageNames = ["bodyScan", "visualization", "noting", "lovingKindness", "reflection", "skillfulCompassion", "restingAwareness", "focusedAttention"]

func uploadCoverImages(){
    for imageName in imageNames{
        //Convert Image to Data
        let imageData = UIImageJPEGRepresentation(UIImage(named: imageName)!, 0.7)
        //Save Item Image
        let imageFileName = String(format: "%@CoverImage.jpeg", imageName)
        let storageRef = Storage.storage().reference()
        _ = storageRef.child(minisDatabase).child(imageName).child(imageFileName).putData(imageData!, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
            }
            // Metadata contains file metadata such as size, content-type, and download URL.
            let downloadURL: URL = metadata.downloadURL()!
            print("\(imageName): \(downloadURL.absoluteString)")
        }
    }
}

func uploadImages(){
    for imageName in imageNames{
        //Convert Image to Data
        let imageData = UIImageJPEGRepresentation(UIImage(named: imageName)!, 0.7)
        //Save Item Image
        let imageFileName = String(format: "%@Image.jpeg", imageName)
        let storageRef = Storage.storage().reference()
        _ = storageRef.child(minisDatabase).child(imageName).child(imageFileName).putData(imageData!, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
            }
            // Metadata contains file metadata such as size, content-type, and download URL.
            let downloadURL: URL = metadata.downloadURL()!
            print("\(imageName): \(downloadURL.absoluteString)")
        }
    }
}

let videoNames = ["gettingStarted", "changingPerspective", "lettingGoOfEffort", "underlyingCalm", "acceptingTheMind", "amIDoingItRight", "amIMakingProgress", "getBackOnTheWagon", "learningASkill", "holeInTheRoad", "plantingASeed", "bodyScan", "visualization", "noting", "lovingKindness", "reflection", "skillfulCompassion", "restingAwareness", "focusedAttention"]

func uploadVideos(){
    for videoName in videoNames{
        //Convert Video to Data
        guard let videoPath = Bundle.main.path(forResource: videoName, ofType: "mp4") else {
            debugPrint("video not found")
            return
        }
        let videoFilePath = URL(fileURLWithPath: videoPath)
        //Save Video
        let videoFileName = String(format: "%@Video.mp4", videoName)
        let storageRef = Storage.storage().reference()
        _ = storageRef.child(animationsDatabase).child(videoName).child(videoFileName).putFile(from: videoFilePath, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
            }
            // Metadata contains file metadata such as size, content-type, and download URL.
            let downloadURL: URL = metadata.downloadURL()!
            print("\(videoName): \(downloadURL.absoluteString)")
        }
    }
}

func uploadPlans(){
    //Plan Data Array
    var planDataArray = [Dictionary<String, Any>]()
    
    //Create Plan Data
    let ref = Database.database().reference()
    for i in stride(from: 0, to: planNames.count, by: 1) {
        var planData = Dictionary<String, Any>()
        planData["objectId"] = ref.childByAutoId().key
        planData["createdAt"] = ServerValue.timestamp()
        planData["updatedAt"] = ServerValue.timestamp()
        planData["name"] = planNames[i]
        planData["price"] = planPrices[i]
        planData["promotionalDetail"] = planPromotionalDetails[i]
        planData["period"] = planPeriods[i]
        planData["periodName"] = planPeriodNames[i]
        planData["priority"] = planPriorities[i]
        planDataArray.append(planData)
    }
    
    //Upload Plan to Database
    for planData in planDataArray{
        ref.child(plansDatabase).child(planData["objectId"] as! String).setValue(planData) { (error:Error?, DatabaseReference) in
            if((error) != nil){
                print("Error uploading plan")
            }
        }
    }
}

//Sample Product Raw Data
let planNames = ["monthly", "annual", "lifetime"]
let planPrices = [12.99, 94.99, 399.99]
let planPromotionalDetails = ["", "Most Popular", ""]
let planPeriods = [0, 12, 0]
let planPeriodNames = ["perMonth", "perYear", "onePayment"]
let planPriorities = [0, 1, 2]




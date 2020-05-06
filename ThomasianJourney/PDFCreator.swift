//
//  PDFCreator.swift
//  ThomasianJourney
//
//  Created by Charmagne Adonis on 5/6/20.
//  Copyright © 2020 Capstone Project. All rights reserved.
//

import UIKit
import PDFKit

class PDFCreator: NSObject {
  
  let title: String
  let image: UIImage
  let eventID: String
  let eventTitle: String
  let eventVenue: String
  let eventDate: String
  let eventTime: String
  let studentNo: String
  let studentName: String
  let referenceNo: String
  
  init(title: String, image: UIImage, eventID: String, eventTitle: String, eventVenue: String, eventDate: String, eventTime: String, studentNo: String, studentName: String, referenceNo: String) {
    self.title = title
    self.image = image
    self.eventID = eventID
    self.eventTitle = eventTitle
    self.eventVenue = eventVenue
    self.eventDate = eventDate
    self.eventTime = eventTime
    self.studentNo = studentNo
    self.studentName = studentName
    self.referenceNo = referenceNo
  }
  
  func createFlyer() -> Data {
    // 1
    let pdfMetaData = [
      kCGPDFContextCreator: "Thomasian Journey",
      kCGPDFContextAuthor: "Thomasian Journey",
      kCGPDFContextTitle: title
    ]
    let format = UIGraphicsPDFRendererFormat()
    format.documentInfo = pdfMetaData as [String: Any]
    
    // 2
    let pageWidth = 8.5 * 72.0
    let pageHeight = 11 * 72.0
    let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
    
    // 3
    let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
    // 4
    let data = renderer.pdfData { (context) in
      // 5
      context.beginPage()
      // 6
      let titleBottom = addTitle(pageRect: pageRect)
      addImage(pageRect: pageRect, imageTop: titleBottom + 18.0)
      let eventIDbottom = addEventID(pageRect: pageRect, textTop: titleBottom + 40.5)
      let eventTitlebottom = addEventTitle(pageRect: pageRect, textTop: eventIDbottom + 3)
      let eventVenuebottom = addEventVenue(pageRect: pageRect, textTop: eventTitlebottom + 3)
      let eventDatebottom = addEventDate(pageRect: pageRect, textTop: eventVenuebottom + 3)
      let eventTimebottom = addEventTime(pageRect: pageRect, textTop: eventDatebottom + 3)
      let studentNobottom = addStudentNo(pageRect: pageRect, textTop: eventTimebottom + 11.5)
      let studentNamebottom = addStudentName(pageRect: pageRect, textTop: studentNobottom + 3)
      addReferenceNo(pageRect: pageRect, textTop: studentNamebottom + 9)

    }
    
    return data
  }
  
  func addTitle(pageRect: CGRect) -> CGFloat {
    // 1
    let titleFont = UIFont.systemFont(ofSize: 18.0, weight: .bold)
    // 2
    let titleAttributes: [NSAttributedString.Key: Any] =
      [NSAttributedString.Key.font: titleFont]
    let attributedTitle = NSAttributedString(string: title, attributes: titleAttributes)
    // 3
    let titleStringSize = attributedTitle.size()
    // 4
    let titleStringRect = CGRect(x: (pageRect.width - titleStringSize.width) / 2.0,
                                 y: 36, width: titleStringSize.width,
                                 height: titleStringSize.height)
    // 5
    attributedTitle.draw(in: titleStringRect)
    // 6
    return titleStringRect.origin.y + titleStringRect.size.height
  }
  
  func addImage(pageRect: CGRect, imageTop: CGFloat) {
    // 1
    let maxHeight = pageRect.height * 0.1
    let maxWidth = pageRect.width * 0.1
    // 2
    let aspectWidth = maxWidth / image.size.width
    let aspectHeight = maxHeight / image.size.height
    let aspectRatio = min(aspectWidth, aspectHeight)
    // 3
    let scaledWidth = image.size.width * aspectRatio
    let scaledHeight = image.size.height * aspectRatio
    // 4
    let imageX = (pageRect.width - scaledWidth) / 2.0
    let imageRect = CGRect(x: imageX, y: imageTop,
                           width: scaledWidth, height: scaledHeight)
    // 5
    image.draw(in: imageRect)
    //return imageRect.origin.y + imageRect.size.height
  }
  
  func addEventID(pageRect: CGRect, textTop: CGFloat) -> CGFloat {
    
    let titleFont = UIFont.systemFont(ofSize: 1.5)
    let titleAttributes: [NSAttributedString.Key: Any] =
      [NSAttributedString.Key.font: titleFont]
    let attributedTitle = NSAttributedString(string: eventID, attributes: titleAttributes)
    let titleStringSize = attributedTitle.size()
    let titleStringRect = CGRect(x: 291.5, y: textTop, width: titleStringSize.width, height: titleStringSize.height)
    attributedTitle.draw(in: titleStringRect)
    return titleStringRect.origin.y + titleStringRect.size.height
  
  }
  
  func addEventTitle(pageRect: CGRect, textTop: CGFloat) -> CGFloat {
    
    let titleFont = UIFont.systemFont(ofSize: 1.5)
    let titleAttributes: [NSAttributedString.Key: Any] =
      [NSAttributedString.Key.font: titleFont]
    let attributedTitle = NSAttributedString(string: eventTitle, attributes: titleAttributes)
    let titleStringSize = attributedTitle.size()
    let titleStringRect = CGRect(x: 295.5, y: textTop, width: titleStringSize.width, height: titleStringSize.height)
    attributedTitle.draw(in: titleStringRect)
    return titleStringRect.origin.y + titleStringRect.size.height
  
  }
  
  func addEventVenue(pageRect: CGRect, textTop: CGFloat) -> CGFloat {
    
    let titleFont = UIFont.systemFont(ofSize: 1.5)
    let titleAttributes: [NSAttributedString.Key: Any] =
      [NSAttributedString.Key.font: titleFont]
    let attributedTitle = NSAttributedString(string: eventVenue, attributes: titleAttributes)
    let titleStringSize = attributedTitle.size()
    let titleStringRect = CGRect(x: 289, y: textTop, width: titleStringSize.width, height: titleStringSize.height)
    attributedTitle.draw(in: titleStringRect)
    return titleStringRect.origin.y + titleStringRect.size.height
  
  }
  
  func addEventDate(pageRect: CGRect, textTop: CGFloat) -> CGFloat {
    
    let titleFont = UIFont.systemFont(ofSize: 1.5)
    let titleAttributes: [NSAttributedString.Key: Any] =
      [NSAttributedString.Key.font: titleFont]
    let attributedTitle = NSAttributedString(string: eventDate, attributes: titleAttributes)
    let titleStringSize = attributedTitle.size()
    let titleStringRect = CGRect(x: 286.5, y: textTop, width: titleStringSize.width, height: titleStringSize.height)
    attributedTitle.draw(in: titleStringRect)
    return titleStringRect.origin.y + titleStringRect.size.height
  
  }
  
  func addEventTime(pageRect: CGRect, textTop: CGFloat) -> CGFloat {
    
    let titleFont = UIFont.systemFont(ofSize: 1.5)
    let titleAttributes: [NSAttributedString.Key: Any] =
      [NSAttributedString.Key.font: titleFont]
    let attributedTitle = NSAttributedString(string: eventTime, attributes: titleAttributes)
    let titleStringSize = attributedTitle.size()
    let titleStringRect = CGRect(x: 287.5, y: textTop, width: titleStringSize.width, height: titleStringSize.height)
    attributedTitle.draw(in: titleStringRect)
    return titleStringRect.origin.y + titleStringRect.size.height
  
  }
  
  func addStudentNo(pageRect: CGRect, textTop: CGFloat) -> CGFloat {
    
    let titleFont = UIFont.systemFont(ofSize: 1.5)
    let titleAttributes: [NSAttributedString.Key: Any] =
      [NSAttributedString.Key.font: titleFont]
    let attributedTitle = NSAttributedString(string: studentNo, attributes: titleAttributes)
    let titleStringSize = attributedTitle.size()
    let titleStringRect = CGRect(x: 297.5, y: textTop, width: titleStringSize.width, height: titleStringSize.height)
    attributedTitle.draw(in: titleStringRect)
    return titleStringRect.origin.y + titleStringRect.size.height
  
  }
  
  func addStudentName(pageRect: CGRect, textTop: CGFloat) -> CGFloat {
    
    let titleFont = UIFont.systemFont(ofSize: 1.5)
    let titleAttributes: [NSAttributedString.Key: Any] =
      [NSAttributedString.Key.font: titleFont]
    let attributedTitle = NSAttributedString(string: studentName, attributes: titleAttributes)
    let titleStringSize = attributedTitle.size()
    let titleStringRect = CGRect(x: 288.5, y: textTop, width: titleStringSize.width, height: titleStringSize.height)
    attributedTitle.draw(in: titleStringRect)
    return titleStringRect.origin.y + titleStringRect.size.height
  
  }
  
  func addReferenceNo(pageRect: CGRect, textTop: CGFloat) {
    
    let titleFont = UIFont.systemFont(ofSize: 1.5)
    let titleAttributes: [NSAttributedString.Key: Any] =
      [NSAttributedString.Key.font: titleFont]
    let attributedTitle = NSAttributedString(string: referenceNo, attributes: titleAttributes)
    let titleStringSize = attributedTitle.size()
    let titleStringRect = CGRect(x: 304.5, y: textTop, width: titleStringSize.width, height: titleStringSize.height)
    attributedTitle.draw(in: titleStringRect)
  
  }
  
}

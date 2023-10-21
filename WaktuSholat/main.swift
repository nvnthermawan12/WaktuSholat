//
//  main.swift
//  WaktuSholat
//
//  Created by Novianto Hermawan on 21/10/23.
//

import Foundation

let currentMonth = Calendar.current.component(.month, from: Date())
let currentDay = Calendar.current.component(.day, from: Date())
var longitude: Double = 0
var latitude: Double = 0

print("Welcome to Swift Jadwal Shalat\n")

print("Masukkan longitude:\n")
if let inputLongitude = readLine(), let longitudeValue = Double(inputLongitude) {
    longitude = longitudeValue
} else {
    print("invalid longitude")
    exit(1)
}

print("Masukkan latitude:\n")
if let inputLatitude = readLine(), let latitudeValue = Double(inputLatitude) {
    latitude = latitudeValue
} else {
    print("invalid latitude")
    exit(1)
}

print("\n")

let latitudeRadians: Double = latitude * .pi / 180
let timezone: Double = 7

var longitudeHours = (longitude / 360) * 24
var totalDaysPassed: Int = 0

var declinationAngle: Double = 0
var localTime: Double = 0
var sholatTime: Double = 0

func calculatePrayerTime(hourAngle: Int, zenithAngle: Double) {
    
    // Calculate the Julian date based on the total days passed plus the current day.
    let julianDate = Double(totalDaysPassed + currentDay) + (Double(hourAngle) - longitudeHours) / 24
    
    // Calculate the mean longitude of the sun based on the Julian date.
    let meanLongitude = (0.9856 * julianDate - 3.289) * .pi / 180
    
    // Compute the true longitude of the sun considering the sun's anomaly.
    let trueLongitude = meanLongitude + 1.916 * .pi / 180 * sin(meanLongitude) + 0.02 * .pi / 180 * sin(2 * meanLongitude) + 282.634 * .pi / 180
    
    // Convert true longitude of the sun from degrees to hours.
    let trueLongitudeInHours = trueLongitude / .pi * 12
    
    // Determine the sun's quadrant based on its true longitude.
    var sunQuadrant = Int(trueLongitudeInHours / 6) + 1
    
    if sunQuadrant % 2 != 0 {
        sunQuadrant -= 1
    }
    
    // Calculate the sun's Ascending Right Ascension.
    let rightAscension = atan(0.91746 * tan(trueLongitude)) / .pi * 12
    
    // Adjust the Right Ascension based on the sun's quadrant.
    let adjustedRightAscension = rightAscension + Double(sunQuadrant * 6)
    
    // Calculate the sun's declination.
    let sinDeclination = 0.39782 * sin(trueLongitude)
    
    // Calculate the time angle based on zenithAngle, declination, and latitude.
    let cosDeclination = sqrt(1 - sinDeclination * sinDeclination)
    declinationAngle = (cos(zenithAngle) - sinDeclination * sin(latitudeRadians)) / (cosDeclination * cos(latitudeRadians))
    
    if abs(declinationAngle) > 1 {
        return
    }
    
    // Compute the time angle in degrees.
    var atanDeclination = atan(sqrt(1 - declinationAngle * declinationAngle) / declinationAngle) / .pi * 180
    if atanDeclination < 0 {
        atanDeclination += 180
    }
    
    // Compute the sun's rising or setting time in hours.
    let timeBeforeOrAfterNoon = (360 - atanDeclination) * 24 / 360
    var adjustedTime = timeBeforeOrAfterNoon
    
    if hourAngle == 18 {
        adjustedTime = 24 - timeBeforeOrAfterNoon
    }
    
    // Calculate the local solar time based on sun's rising/setting time, Right Ascension, and Julian date.
    localTime = adjustedTime + adjustedRightAscension - (0.06571 * julianDate) - 6.622
    localTime += 24
    localTime -= Double(Int(localTime / 24) * 24)
    
    sholatTime = localTime - longitudeHours + timezone
}

let daysInMonths = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
var monthCount: Int = 1
let prayerNames = ["Date", "Fajr", "Sunrise", "Dhuhr", "Asr", "Maghrib", "Isha"]

for name in prayerNames {
    print("\(name)\t", terminator: "")
}
print("\n")

for days in daysInMonths {
    for k in 1...days {
        var prayerTimes: [Double] = [0, 0, 0, 0, 0, 0]
        totalDaysPassed += 1
        
        // shubuh
        calculatePrayerTime(hourAngle: 6, zenithAngle: 108 * .pi / 180)
        if abs(declinationAngle) <= 1 {
            prayerTimes[0] = sholatTime
        }
        
        // sunrise
        calculatePrayerTime(hourAngle: 6, zenithAngle: (90 + 5/6) * .pi / 180)
        prayerTimes[1] = sholatTime
        
        calculatePrayerTime(hourAngle: 18, zenithAngle: (90 + 5/6) * .pi / 180)
        let sunsetTime = sholatTime
        // maghrib
        prayerTimes[4] = sunsetTime + 2/60
        
        // isya'
        calculatePrayerTime(hourAngle: 18, zenithAngle: 108 * .pi / 180)
        if abs(declinationAngle) <= 1 {
            prayerTimes[5] = sholatTime
        }
        
        // dhuhur
        let middayTime = (prayerTimes[1] + sunsetTime) / 2
        prayerTimes[2] = middayTime + 2/60
        
        // asr
        prayerTimes[3] = (prayerTimes[2] + prayerTimes[4]) / 2
        
        if monthCount == currentMonth {
            print("\(k)\t", terminator: "")
            for prayer in prayerTimes {
                let prayerHour = Int(prayer)
                let prayerMinute = Int((prayer - Double(prayerHour)) * 60)
                print("\(prayerHour):\(prayerMinute)\t", terminator: "")
            }
            print("\n")
        }
    }
    monthCount += 1
}


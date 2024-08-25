 abstract sig Transportation {
	route: String,
        capacity: Int,
        platform: set Platform,
        nextArrival: one Time,
        lastDeparture: one Time,
        expectedTravelTime: one Time
 }

 sig Bus extends Transportation { }

 sig Train extends Transportation { }

 sig Station {
     name: String,
     platforms: set Platform
 }

 sig Platform {
     number: Int,
     transportation: set Transportation,
     securityPersonel: set Person
 }

 sig Time{}
 sig Person{}

 fact capacity {
     all t: Transportation | t.capacity > 0
 }

 fact differentRoutes {
     all t1, t2: Transportation | 
         t1 != t2 => t1.route != t2.route
 }

 assert uniquePlatformNumber {
     all p1, p2: Platform | 
         p1 != p2 => p1.number != p2.number
 }

 fact noOvercrowding {
     all p: Platform | 
         sum t: p.transportation | t.capacity <= p.transportation.capacity
 }


 assert trainsAndBusesOnDifferentPlatforms {
     all t1, t2: Transportation | 
         t1 != t2 && t1 in Bus + Train && t2 in Bus + Train => 
             t1.platform != t2.platform
 }

 fact maxWaitingTime {
     all t: Transportation, p: Platform | 
         t.platform = p => 
             t.nextArrival - p.lastDeparture <= 30
 }

 fact noLoitering {
     all p: Platform, c: Customer | 
         c.location = p => 
             c.timeOnPlatform <= 15
 }

 assert enoughSecurity {
     all p: Platform | 
         p.securityPersonnel.count >= p.transportation.capacity / 100
 }

 assert transportationRoute {
     all t: Transportation | t.route != ""
 }

 assert onlyExpressTrainsOnExpressPlatform {
     all p: Platform, t: Train | 
         p.transportation.has(t) && t.route = "Express" => 
             p.number < 20
 }

 fact onTimeArrival {
     all t: Train | t.nextArrival - t.lastDeparture <= t.expectedTravelTime
 }







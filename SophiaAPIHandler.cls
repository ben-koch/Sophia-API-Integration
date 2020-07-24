/* 
 * BTK
 * Redpath Consulting Group
 * May 2020
 */

public class SophiaAPIHandler {
        
    public String requestMethod = '';
    public String tokenSecret = '';
    public String endpoint = '';
    public API_Setting__mdt settings {get;set;}

    // we will use this to store the course credit information for all courses
    public Map<String,Decimal> courseCreditsMap = New Map<String,Decimal>();
  	
    /* @description main method - called from the SophiaAPIBatch class
     * @returns list of Sophia Course objects to be upserted
     */
    public List<Sophia_Course__c> getSophiaCourses(Contact student, API_Setting__mdt setting){       
        settings = setting;
        requestMethod = 'GET';
        //the endpoint we are connecting to
        endpoint = 'https://api.sophia.org/api/v1.1/student_by_external_id/'+student.CRM_ID__c+'/courses';
        
        //jsonStr will be the response/error message if the callout fails, which will make dummyCourses null
        String jsonStr = getJSON();
        
        // call createDummyCourses to parse through the list of courses for this student and create dummyCourse objects for each of them
        // we will use the course ids to get the report for our custom Sophia_Course__c object
        List<DummyCourse> dummyCourses = createDummyCourses(jsonStr); 
        
        //create new List<Sophia_Course__c> objects. these will be upserted in the batch class
        List<Sophia_Course__c> sophiaCourses = new List<Sophia_Course__c>();
        
        if (!dummyCourses.isEmpty()){	// this will be null if getJSON fails initially
            for (DummyCourse dc : dummyCourses){     
                // change endpoint to retrieve student data for a specific dummy course id
                endpoint = 'https://api.sophia.org/api/v1.1/courses/'+dc.id+'/student_by_external_id/'+student.CRM_ID__c+'/report'; 
                // make the callout to the new endpoint and set jsonStr = the json response
                jsonStr = getJSON();
                //Instantiate the SophiaJSONHandler class and call its parse method to iterate through and store the JSON information
                SophiaJSONHandler sjh = SophiaJSONHandler.parse(jsonStr);
                //create a new sophia course object and assign its attributes from the elements stored in the sjh object.
                Sophia_Course__c sc = createSophiaCourse(sjh,student);
                //add the new sophia course object to the list to be passed back to the batch class for upserting
                sophiaCourses.add(sc);
            }
        }
    	return sophiaCourses;
    }
    
    /**
    * @description Makes a callout to Sophia using 2-legged OAuth 1.0
    * @return the json retrieved from the endpoint
    **/   
        public String getJSON(){
            Integer count = Limits.getDMLRows();         
            //get the current datetime
            Datetime dt = Datetime.now();
            //getTime() returns the number of milliseconds since 1/1/1970 divide by 1000 to get seconds (epoch time)
			Long oauthTimestamp = (dt.getTime()) / 1000; 
            system.debug('timestamp = ' + oauthTimestamp);
            //generate a random string for nonce variable
            String oauthNonce= EncodingUtil.convertToHex(Crypto.generateAesKey(128)).substring(0, 20);
            system.debug('nonce = ' + oauthNonce);
            
      		//concatenate all oauth parameters into a string
            String params = 'oauth_consumer_key=' + settings.oauth_consumer_key__c + '&oauth_nonce=' + oauthNonce + '&oauth_signature_method=' + settings.oauth_signature_method__c + '&oauth_timestamp=' + oauthTimestamp;
            //request method, base string URI, and parameters (in ascending order after encoding (if necessary))
            String baseString = requestMethod + '&' + EncodingUtil.urlEncode(endpoint, 'UTF-8') + '&' + EncodingUtil.urlEncode(params, 'UTF-8');
            String signatureKey = settings.oauth_shared_secret__c + '&' + tokenSecret;     
            
            //use the baseString and signatureKey to create the HMAC signature. base64encode it to change it from Blob to String
            String oauthSignature = EncodingUtil.base64Encode(generateHmacSHA1Signature(baseString,signatureKey));
            system.debug('signature = ' + oauthSignature);
            //concatenate elements to create the URL we will be sending in our HTTP request
            String requestTokenURL = endpoint + '?oauth_consumer_key=' + settings.oauth_consumer_key__c + '&oauth_signature_method=' + settings.oauth_signature_method__c + '&oauth_signature=' + EncodingUtil.urlEncode(oauthSignature, 'UTF-8') + '&oauth_timestamp=' + oauthTimestamp + '&oauth_nonce=' + oauthNonce;

    		// Instantiate a new http object
            Http h = new Http();
        
            // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
            HttpRequest req = new HttpRequest();
            req.setEndpoint(requestTokenURL);
            req.setMethod(requestMethod);
            
            // Create the variable which will hold the json response
            String jsonStr = '';
            
            // Check to see if it's a test before sending the request
        	if (!Test.isRunningTest()) {
                try{
                    // Send the request, and return a response
                    HttpResponse response = h.send(req);
                    if (response.getStatusCode() == 200) {
                        jsonStr = response.getBody();
                        system.debug('Successful request');
                    }else{
                        jsonStr = response.toString();
                        system.debug('Unsuccessful request. Error code: ' + jsonStr);
                    }
                }catch (Exception e){
                    system.debug('Error:' + e.getMessage() + 'LN:' + e.getLineNumber());          
                }
            }
            return jsonStr;
        }
    
    	// method to generate SHA 1
		private static blob generateHmacSHA1Signature(String canonical_str, String secretKey){ 
        	Blob mac = Crypto.generateMac('hmacSHA1', blob.valueof(canonical_str),blob.valueof(secretKey)); 
         	return mac;
 		}
    	
    	// method to parse through the JSON response of the get courses endpoint and create dummy courses via the DummyCourse class below
        public List<DummyCourse> createDummyCourses(String jsonStr) {       
            
            List<DummyCourse> dummyCourses = New List<DummyCourse>();
            
            // Parse entire JSON response.
            JSONParser parser = JSON.createParser(jsonStr);
            while (parser.nextToken() != null) {
                // Start at the array of courses.
                if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
                    while (parser.nextToken() != null) {
                        // Advance to the start object marker to
                        //  find next invoice statement object.
                        if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                            // Read entire invoice object, including its array of line items.
                            DummyCourse dCourse = (DummyCourse)parser.readValueAs(DummyCourse.class);
                            system.debug('Course ID: ' + dCourse.id);
                            system.debug('Course Title: ' + dCourse.title);
                            system.debug('Course Credits: ' + dCourse.credits);
                            // For debugging purposes, serialize again to verify what was parsed.
                            String s = JSON.serialize(dCourse);
                            system.debug('Serialized course: ' + s);
        
                            // Skip the child start array and start object markers.
                            parser.skipChildren();
                            courseCreditsMap.put(dCourse.id,dCourse.credits);
                            dummyCourses.add(dCourse);
                        }
                    }
                }
            }
            return dummyCourses;
    	}
    	
    	//takes in the SophiaJSONHandler instance and populates the fields on the new Sophia Course object from the data stored in the SophiaJSONHandler inner class instances
        public Sophia_Course__c createSophiaCourse(SophiaJSONHandler handler, Contact student){     
            SophiaJSONHandler sjh = handler;
            Sophia_Course__c sc = New Sophia_Course__c();
            sc.Course_ID__c = sjh.data.courses[0].id;
            sc.Course_Start_Date__c = sjh.data.courses[0].activity.start_date;
            sc.Course_End_Date__c = sjh.data.courses[0].activity.end_date;
            sc.Name = sjh.data.courses[0].title;
            sc.MLS_Completed__c = sjh.data.courses[0].overview.milestones_completed + ' of ' + sjh.data.courses[0].overview.total_milestones;
            sc.Student__c = student.id;
            sc.Key__c = sc.Student__c + sc.Course_ID__c;
            if(sjh.data.courses[0].activity.state.contains('complete_and_certified')){
                sc.Credits_Completed__c = courseCreditsMap.get(sjh.data.courses[0].id);
                sc.Credits_In_Progress__c = 0;
            }else{
                sc.Credits_Completed__c = 0;
                sc.Credits_In_Progress__c = courseCreditsMap.get(sjh.data.courses[0].id);
            }
            return sc;
        }
    
        // Inner classes used when parsing JSON
        public class DummyCourse {
            public String id;
            public String title;
            public Decimal credits;
            
            public DummyCourse(String dummyCourseId, String dummyCourseTitle, Decimal dummyCredits) {
                id = dummyCourseId;
                title = dummyCourseTitle;
                if(dummyCredits == null){
                    credits = 0;
                }else{
                    credits = dummyCredits;
                }
            }
        }
}
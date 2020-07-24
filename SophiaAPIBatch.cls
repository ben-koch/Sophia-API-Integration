global class SophiaAPIBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {
    // collect the batches of records or objects to be passed to execute
    global Database.QueryLocator start(Database.BatchableContext bc) {
        
        // get all student IDs with related Sophia Course objects
        String query = 'SELECT CRM_ID__c FROM Contact WHERE CRM_ID__c != null';
		return Database.getQueryLocator(query);
    }
    // process each batch of records
    global void execute(Database.BatchableContext bc, List<Contact> students){
        // get custom metadata type to use for API callout
        API_Setting__mdt settings = [SELECT Endpoint__c, oauth_consumer_key__c, oauth_shared_secret__c, 
                                        oauth_signature_method__c, Username__c, Password__c 
                                        FROM API_Setting__mdt
                                        WHERE Label = 'Sophia API'];
        
        // create the list of Sophia_Course__c objects to be upserted
        List<Sophia_Course__c> sophiaCourses = New List<Sophia_Course__c>();
        
        // instantiate SophiaAPIHandler class
        SophiaAPIHandler handler = New SophiaAPIHandler();
        
        // for every Sophia student, get a list of their related Sophia Course objects and add them to the master list
        for (Contact student : students){
            sophiaCourses.addAll(handler.getSophiaCourses(student, settings));
        }
        try {
        	upsert sophiaCourses Key__c;    // This line upserts the sophiaCourses list with the Key__c field specified as the field 
            								// that should be used to determine if the sophia course object already exists. 
            								// If it does, it will be updated. If it doesn't, it will be inserted.
        } catch (DmlException e) {
            System.debug(e.getMessage());
        }
		
    }
    // execute any post-processing operations    
    global void finish(Database.BatchableContext bc){

    }    
}
@isTest
public class SophiaAPIBatchTest {
    
    @testSetup 
    static void setup() {
        
        Account testAccount = New Account(Name = 'Test Account');
        insert testAccount;
        
		Contact testContact = New Contact(FirstName = 'Testy', LastName = 'Tester', accountId = testAccount.Id, CRM_ID__c = '2402673', Email = 'test@email.com');
        insert testContact;
    }
    
    static testmethod void executeTest(){
        Test.startTest();
        SophiaAPIBatch batchClass = New SophiaAPIBatch();
        Database.executeBatch(batchClass);
        Test.stopTest();
    }
}
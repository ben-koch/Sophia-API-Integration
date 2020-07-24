@isTest
public class ScheduleSophiaAPIBatchTest {
    
    public static String testCron ='0 45 23 ? * SAT';
    
    static testmethod void executeTest(){
        ScheduleSophiaAPIBatch schedClass = New ScheduleSophiaAPIBatch();
        Test.startTest();
        System.schedule('Test Schedule', testCron, schedClass);
        Test.stopTest();
    }
}
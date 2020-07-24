//to schedule this class to run every saturday at 11:45pm local time
   //enter the following into execute anonymous and then press execute:
   //
   //global static final String DEFAULT_SCHEDULE = '0 45 23 ? * SAT';
   //ScheduleSophiaAPIBatch job = New ScheduleSophiaAPIBatch();
   //System.Schedule('Schedule Sophia API Batch Job',DEFAULT_SCHEDULE,job); 

global class ScheduleSophiaAPIBatch implements Schedulable {
   
   global void execute(SchedulableContext SC) {
       SophiaAPIBatch sab = New SophiaAPIBatch();
       Database.executebatch(sab);
   }
}
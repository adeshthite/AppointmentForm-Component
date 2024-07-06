public class AppointmentSlotApex {

    @AuraEnabled(cacheable=true)
    public static List<Date> appoappointment() {
        List<Date> dates = new List<Date>();
        
        List<Appointment_Detail__c> slots = [SELECT Appointment_Date__c FROM Appointment_Detail__c ];
        
        for (Appointment_Detail__c slot : slots) {
            dates.add(slot.Appointment_Date__c); 
        }
        return dates;
    }


     @AuraEnabled(cacheable=true)
    public static Boolean checkDuplicateAppointment(String appoinmentTimes,Date appoinmentDatess ) {
        try {
            List<String> timeParts = appoinmentTimes.split(':');
            Integer hours = Integer.valueOf(timeParts[0]);
            Integer minutes = Integer.valueOf(timeParts[1]);
            Integer seconds = Integer.valueOf(timeParts[2]);
            
            Time appointmentTime = Time.newInstance(hours, minutes, seconds, 0);
            List<Appointment_Slot__c> appointments = [SELECT Id FROM Appointment_Slot__c WHERE Start_Time__c = :appointmentTime and Appointment_Date__c=: appoinmentDatess and isActive__c = TRUE];
            return appointments.size() > 0;

        } catch (Exception e) {
            throw new AuraHandledException('Invalid time format: ' + appoinmentTimes);
        }
    }

     @AuraEnabled(cacheable=true)
    public static Boolean checkDuplicateAppointments(String appoinmentTimes,Date appoinmentDatess ) {
         if (checkDuplicateAppointment(appoinmentTimes, appoinmentDatess)) {
            throw new AuraHandledException('An appointment already exists for the specified date and time.');
        }
        try {
            List<String> timeParts = appoinmentTimes.split(':');
            Integer hours =   Integer.valueOf(timeParts[0]);
            Integer minutes = Integer.valueOf(timeParts[1]);
            Integer seconds = Integer.valueOf(timeParts[2]);
            
            Time appointmentTime = Time.newInstance(hours, minutes, seconds, 0);
            List<Appointment_Detail__c> appointments = [SELECT Id FROM Appointment_Detail__c WHERE Appointment_Time__c = :appointmentTime and Appointment_Date__c=: appoinmentDatess];
            return appointments.size() > 0;
        } catch (Exception e) {
            throw new AuraHandledException('Invalid time format: ' + appoinmentTimes);
        }
    }

}

global class RC_HRServices_UpdateEmployeeSchedulable implements Schedulable{
    
    global void execute(SchedulableContext ctx) {    
         RC_HRServices_GetUpdatedEmployee.GetUpdatedEmployee();
    }
}
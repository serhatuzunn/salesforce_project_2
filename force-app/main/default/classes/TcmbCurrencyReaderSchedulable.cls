global class TcmbCurrencyReaderSchedulable implements Schedulable, Database.AllowsCallouts{	
    global void execute(SchedulableContext sc){        
        TcmbCurrencyReader.parseResponseDom();
    }
}
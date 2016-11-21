@istest private class REST_Passenger_V1_Tests {
    
    //Declare variables that will be used in test
    private static Account personAcc;
    private static Account businessAcc;
    private static Passenger__c pass;
    private static Booking_Passenger__c bPass;
    private static Booking_Component__c bComp;
    private static Booking__c book;
    
    //First test will successfully find a booking and move it to the current account
    @isTest
    static void callAPIForTestResults1(){    
        
        //create records
        CreateRecords();
        
        test.startTest();
            
        System.RestContext.request = new RestRequest();
        System.RestContext.response = new RestResponse();  
        RestContext.request.httpMethod = 'PATCH';
        
        Account a = new Account(firstName = 'a', lastName = 'b', recordTypeId = Schema.SObjectType.Account.getRecordtypeInfosByName().get('Customer').getRecordTypeId());
        insert a;
        
        //call the PATCH method on the Rest API class and envolk the ContactWrapper list
        REST_Passenger_V1.PassengerWrapper results = REST_Passenger_V1.doPatch('Kenneth', 'Wither', 'A029034', a.Id, 'TTAKLS');      
        
        test.stopTest();
        system.assertEquals(results.status, 'success');
    }
    
    //second test will pass Null value for First Name
    @isTest
    static void callAPIForTestResults2(){    
        
        //create records
        CreateRecords();
        
        test.startTest();
            
        System.RestContext.request = new RestRequest();
        System.RestContext.response = new RestResponse();  
        RestContext.request.httpMethod = 'PATCH';
        
        Account a = new Account(firstName = 'a', lastName = 'b', recordTypeId = Schema.SObjectType.Account.getRecordtypeInfosByName().get('Customer').getRecordTypeId());
        insert a;
        
        //call the PATCH method on the Rest API class and envolk the ContactWrapper list
        REST_Passenger_V1.PassengerWrapper results = REST_Passenger_V1.doPatch(Null, 'Wither', 'A029034', a.Id, 'TTAKLS');      
        
        test.stopTest();
        system.assertEquals(results.status, 'failure');
        system.assertEquals(results.message, 'you must enter a First Name');
    }
    
    //third test will pass Null value for Last Name
    @isTest
    static void callAPIForTestResults3(){    
        
        //create records
        CreateRecords();
        
        test.startTest();
            
        System.RestContext.request = new RestRequest();
        System.RestContext.response = new RestResponse();  
        RestContext.request.httpMethod = 'PATCH';
        
        Account a = new Account(firstName = 'a', lastName = 'b', recordTypeId = Schema.SObjectType.Account.getRecordtypeInfosByName().get('Customer').getRecordTypeId());
        insert a;
        
        //call the PATCH method on the Rest API class and envolk the ContactWrapper list
        REST_Passenger_V1.PassengerWrapper results = REST_Passenger_V1.doPatch('Kenneth', Null, 'A029034', a.Id, 'TTAKLS');      
        
        test.stopTest();
        system.assertEquals(results.status, 'failure');
        system.assertEquals(results.message, 'you must enter a Last Name');
    }
    
    //fourth test will pass Null value for Booking Reference
    @isTest
    static void callAPIForTestResults4(){    
        
        //create records
        CreateRecords();
        
        test.startTest();
            
        System.RestContext.request = new RestRequest();
        System.RestContext.response = new RestResponse();  
        RestContext.request.httpMethod = 'PATCH';
        
        Account a = new Account(firstName = 'a', lastName = 'b', recordTypeId = Schema.SObjectType.Account.getRecordtypeInfosByName().get('Customer').getRecordTypeId());
        insert a;
        
        //call the PATCH method on the Rest API class and envolk the ContactWrapper list
        REST_Passenger_V1.PassengerWrapper results = REST_Passenger_V1.doPatch('Kenneth', 'Wither', Null, a.Id, 'TTAKLS');      
        
        test.stopTest();
        system.assertEquals(results.status, 'failure');
        system.assertEquals(results.message, 'you must enter a booking reference');
    }
    
    //fifth test will pass data which return no Bookings
    @isTest
    static void callAPIForTestResults5(){    
        
        //create records
        CreateRecords();
        
        test.startTest();
            
        System.RestContext.request = new RestRequest();
        System.RestContext.response = new RestResponse();  
        RestContext.request.httpMethod = 'PATCH';
        
        Account a = new Account(firstName = 'a', lastName = 'b', recordTypeId = Schema.SObjectType.Account.getRecordtypeInfosByName().get('Customer').getRecordTypeId());
        insert a;
        
        //call the PATCH method on the Rest API class and envolk the ContactWrapper list
        REST_Passenger_V1.PassengerWrapper results = REST_Passenger_V1.doPatch('John', 'Wither', 'A029034', a.Id, 'TTAKLS');      
        
        test.stopTest();
        system.assertEquals(results.status, 'failure');
        system.assertEquals(results.message, 'No bookings were found based on that criteria');
    }
    
    public static void createRecords(){
    
        //grab record type id of Person Account        
        Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordtypeInfosByName().get('Customer').getRecordTypeId();
        
        //grab record type id of Business Unit        
        Id businessUnitRecordTypeId = Schema.SObjectType.Account.getRecordtypeInfosByName().get('Business Unit').getRecordTypeId();
        
        //grab record type id of Passenger        
        Id passengerRecordTypeId = Schema.SObjectType.Passenger__c.getRecordtypeInfosByName().get('Main Passenger').getRecordTypeId();
        
        //grab record type id of Booking Passenger        
        Id bookingPassengerRecordTypeId = Schema.SObjectType.Booking_Passenger__c.getRecordtypeInfosByName().get('Booking Passengers').getRecordTypeId();
        
        //grab record type id of Booking Component        
        Id bookingComponentRecordTypeId = Schema.SObjectType.Booking_Component__c.getRecordtypeInfosByName().get('Tour').getRecordTypeId();
        
        //grab record type id of Booking        
        Id bookingRecordTypeId = Schema.SObjectType.Booking__c.getRecordtypeInfosByName().get('Booking').getRecordTypeId();
        
        
        personAcc = new Account(firstName = 'Kenneth', lastName = 'Wither', recordTypeId = personAccountRecordTypeId);
        insert personAcc;
        
        businessAcc = new Account(name = 'Trafalgar (NZ)', Selling_Company_Short_Name__c = 'TTAKLS', External_Id__c = 'TTAKLS', recordTypeId = businessUnitRecordTypeId);
        insert businessAcc;
        
        book = new Booking__c(name = 'A029034', Selling_Company__c = businessAcc.Id, Lead_Passenger__c = personAcc.Id, Original_Booking_Date__c = date.today(), recordTypeId = bookingRecordTypeId);
        insert book;
        
        bPass = new Booking_Passenger__c(Customer__c = personAcc.Id, Booking__c = book.Id, name = 'TTAKLS#A029034#001', recordTypeId = bookingPassengerRecordTypeId);
        insert bPass;
        
        bComp = new Booking_Component__c(name = 'TTAKLS-A029034-001-BIXPA11-14H16a', Booking_Number__c = book.Id, Customer__c = personAcc.Id, Booking_Passenger__c = bPass.Id, recordTypeId = bookingComponentRecordTypeId);
        insert bComp;
        
        pass = new Passenger__c(name = 'Kenneth Wither', Account__c = personAcc.Id, Passenger_External_Id__c = 'a1e20000007Y9NBAA0-TTAKLS#A029034#001', First_name__c = 'Kenneth', Family_Name__c = 'Wither', Booking_Passenger__c = bPass.Id, Booking_Component__c = bComp.Id, recordTypeId = passengerRecordTypeId);
        insert pass;    
    }
}
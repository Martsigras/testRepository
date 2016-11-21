/*-------------------------------------------------------
*----------API call for mapping bookings-----------------
*----------Used by MTS-----------------------------------
*----------created by Mark Mulholland--------------------
*----------18/10/2016------------------------------------
*--------------------------------------------------------
*/
@RestResource(urlMapping='/v1/Passenger/*')
global with sharing class REST_Passenger_V1 {
    
    @HttpPatch
    global static PassengerWrapper doPatch(String firstName, String lastName, String BookingRef, String accountId, String BookingRegion) {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        PassengerWrapper response = new PassengerWrapper();
        
        //check that the user inputted strings are not blank
        validateInput(firstName, lastName, BookingRef, response);
        
        //if the strings are blank then end the process there are return the failure response
        If(response.status == 'failure'){
        
            return response;
            
        }
        
        else{

            //using the accopuntId passed by the site, create an Account variable
            Account currentAccount = new Account(id = accountId);
            
            //populate passList List with all Passenger records found with the criteria given
            response.passList = [SELECT Id, First_Name__c, Family_Name__c, name, Passenger_External_Id__c, Account__r.Id, Booking_Number__c, Selling_Company_Short_Name__c FROM Passenger__c WHERE First_Name__c = :firstName AND Family_Name__c = :lastName AND Booking_Number__c = :BookingRef AND Selling_Company_Short_Name__c = :BookingRegion];
            
            //if the SOQL query returns no results then send a failure response
            If(response.passList.size() == 0){
            
                response.status = 'failure';
                response.message = 'No bookings were found based on that criteria';
                
                return response;
            
            }
            
            //for each Passenger, first add the currentAccount Id to the person Account on that passenger
            //then overwrite the Person Account reference on Passenger to the currentAccount Account created earlier
            for(integer i = 0; i < response.passList.size(); i++){
            
                response.passList[i].Account__r.Account_To_Be_Mapped__c = currentAccount.Id;
                update response.passList[i].Account__r;
                response.passList[i].Account__c = currentAccount.Id;
            }
            
            update response.passList;
            
            //return the success response letting the user know how many Passenger records are now available to them
            response.status = 'success';
            response.message = 'The selected ' + response.passList.size() + ' Passengers are now visible to you';
                
            return response;
        }
    }
    
    private static void validateInput(String firstName, String lastName, String BookingRef, PassengerWrapper response){
        
        If(BookingRef == Null || BookingRef == ''){
        
            response.status = 'failure';
            response.message = 'you must enter a booking reference';
        
        }
        Else If(lastName == Null || lastName == ''){
        
            response.status = 'failure';
            response.message = 'you must enter a Last Name';
        
        }
        Else If(firstName == Null || firstName == ''){
        
            response.status = 'failure';
            response.message = 'you must enter a First Name';
        
        }
        
    }
    
    global class PassengerWrapper {
        public List<Passenger__c> passList;
        public String status;
        public String message;
        
        public PassengerWrapper(){
            passList = new List<Passenger__c>();
        }
    }
}
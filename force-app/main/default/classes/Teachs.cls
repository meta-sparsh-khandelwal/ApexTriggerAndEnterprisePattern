public class Teachs extends fflib_SObjectDomain {
    public Teachs(List<Teach__c> sObjectList) {
        super(sObjectList);
    }
    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new Teachs(sObjectList);
        }
    }
    public override void onBeforeUpdate(Map<Id,SObject> existingRecords) {
        for(Teach__c tch : (List<Teach__c>) Records) {
            if(tch.Subject__c.contains('Hindi')) {
        		tch.Subject__c.addError('Cannot add Teacher teaching Hindi');
            }
        }
    }
    public override void onBeforeInsert() {
        for(Teach__c tch : (List<Teach__c>) Records) {
            if(tch.Subject__c.contains('Hindi')) {
        		tch.Subject__c.addError('Cannot add Teacher teaching Hindi');
            }
        }
    }
}
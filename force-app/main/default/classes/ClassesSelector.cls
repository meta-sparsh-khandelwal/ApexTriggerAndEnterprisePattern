public class ClassesSelector extends fflib_SObjectSelector {
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Class__c.Id,
                Class__c.Name,
                Class__c.MaxSize__c,
                Class__c.MyCount__c};
                    }
    public Schema.SObjectType getSObjectType() {
        return Class__c.sObjectType;
    }
    public List<Class__c> selectById(Set<ID> idSet) {
        return (List<Class__c>) selectSObjectsById(idSet);
    }
    public List<Class__c> classesWithFemaleStudents(Set<Id> classIdSet) {
        List<Class__c> classList = new List<Class__c>();
        for(Class__c cl : [SELECT Id, Name, 
                           (SELECT FirstName__c, Sex__c FROM Students__r 
                            WHERE Sex__c = 'Female') 
                           FROM Class__c WHERE Id IN :classIdSet]) {
                               if(cl.Students__r.size() > 1) {
                                   classList.add(cl);
                               }
                           }
        return classList;
    }
    public Map<Id, Class__c> getClassesWithId() {
        Map<Id, Class__c> classIdToClassMap = new Map<Id, Class__c>([SELECT Id, MaxSize__c, 
                                                                     (SELECT Id FROM Students__r) 
                                                                     FROM Class__c]);
        return classIdToClassMap;
    }
    public List<Class__c> classHavingStudents(Set<Id> studentIdSet) {
        List<Class__c> classList = [SELECT Id, MaxSize__c, MyCount__c, 
                                    (SELECT Id FROM Students__r 
                                     WHERE Id IN :studentIdSet) FROM Class__c];
        return classList;
    }
}